import './models.dart';

/// Repository interfaces. Widgets and screens depend only on these.
// TODO: Replace with Riverpod providers and real API implementations
abstract class DashboardRepository {
  Future<DashboardData> loadDashboard();
}

abstract class SampleComponentRepository {
  Future<List<Trip>> sampleTrips();
  Future<List<Vehicle>> sampleVehicles();
  Future<List<Bid>> sampleBids();
  Future<List<LoadItem>> sampleLoads();
  Future<List<TimelineItem>> sampleTimeline();
}

abstract class ProfileRepository {
  Future<CompanyProfile> loadProfile();
}
