import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/auth_notifier.dart';

class PinEntryScreen extends ConsumerStatefulWidget {
  final bool isSetup;
  final VoidCallback? onSuccess;

  const PinEntryScreen({super.key, this.isSetup = false, this.onSuccess});

  @override
  ConsumerState<PinEntryScreen> createState() => _PinEntryScreenState();
}

class _PinEntryScreenState extends ConsumerState<PinEntryScreen> {
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  String? _errorMessage;
  bool _canCheckBiometrics = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    final canCheck = await ref.read(authNotifierProvider.notifier).checkBiometrics();
    if (mounted) {
      setState(() => _canCheckBiometrics = canCheck);
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    final success = await ref.read(authNotifierProvider.notifier).authenticateWithBiometrics();
    if (success && mounted) {
      if (widget.onSuccess != null) {
        widget.onSuccess!();
      } else {
        context.go('/');
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Biometric authentication failed or was cancelled'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _submit() async {
    final pin = _pinController.text;
    if (pin.length < 4) {
      setState(() => _errorMessage = 'PIN must be at least 4 digits');
      return;
    }

    if (widget.isSetup) {
      if (pin != _confirmPinController.text) {
        setState(() => _errorMessage = 'PINs do not match');
        return;
      }
      final success = await ref.read(authNotifierProvider.notifier).setPin(pin);
      if (success) {
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('PIN Set Successfully')),
          );
          if (widget.onSuccess != null) {
            widget.onSuccess!();
          } else {
            context.go('/');
          }
        }
      } else {
         setState(() => _errorMessage = 'Failed to set PIN');
      }
    } else {
      final isValid = await ref.read(authNotifierProvider.notifier).verifyPin(pin);
      if (isValid) {
         if (mounted) {
           if (widget.onSuccess != null) {
              widget.onSuccess!();
            } else {
              context.go('/');
            }
         }
      } else {
        setState(() => _errorMessage = 'Incorrect PIN');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(widget.isSetup ? 'Security Setup' : 'Secure Access'),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.isSetup ? Icons.lock_person_rounded : Icons.lock_open_rounded,
                  size: 64,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                widget.isSetup ? 'Create Your PIN' : 'Enter PIN to Continue',
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                widget.isSetup 
                  ? 'Set a 4-6 digit PIN to keep your account safe.' 
                  : 'Please enter your secure PIN to access your account.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 40),
              
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
                
              TextField(
                controller: _pinController,
                decoration: const InputDecoration(
                  labelText: 'Security PIN',
                  prefixIcon: Icon(Icons.password_rounded),
                  counterText: '',
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: const TextStyle(letterSpacing: 10, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              
              if (widget.isSetup) ...[
                const SizedBox(height: 24),
                TextField(
                  controller: _confirmPinController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm PIN',
                    prefixIcon: Icon(Icons.check_circle_outline_rounded),
                    counterText: '',
                  ),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: const TextStyle(letterSpacing: 10, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
              
              const SizedBox(height: 48),
              
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submit,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                  child: Text(widget.isSetup ? 'Set Security PIN' : 'Unlock Account'),
                ),
              ),

              if (_canCheckBiometrics && !widget.isSetup) ...[
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: _authenticateWithBiometrics,
                  icon: const Icon(Icons.face_unlock_rounded),
                  label: const Text('Use Biometrics'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
