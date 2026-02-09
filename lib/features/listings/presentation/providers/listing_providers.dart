import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/datasources/listing_local_data_source.dart';
import '../../data/datasources/listing_remote_data_source.dart';
import '../../data/repositories/listing_repository_impl.dart';
import '../../domain/repositories/listing_repository.dart';


final listingLocalDataSourceProvider = Provider<ListingLocalDataSource>((ref) {
  return ListingLocalDataSourceImpl(Hive.box('favorites'));
});

final listingRemoteDataSourceProvider = Provider<ListingRemoteDataSource>((ref) {
  return ListingRemoteDataSourceImpl();
});


final listingRepositoryProvider = Provider<ListingRepository>((ref) {
  return ListingRepositoryImpl(
    remoteDataSource: ref.watch(listingRemoteDataSourceProvider),
    localDataSource: ref.watch(listingLocalDataSourceProvider),
  );
});
