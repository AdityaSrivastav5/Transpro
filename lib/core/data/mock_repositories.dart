import '../app_state.dart';
import './models.dart';
import './repositories.dart';

// Dates are relative to "now" so the data always feels current.
DateTime _t(Duration offset) => DateTime.now().add(offset);

final List<Map<String, dynamic>> _tripMaps = [
  {
    'id': 'TRP-24871',
    'origin': 'Bhiwandi, MH',
    'destination': 'Gurugram, HR',
    'stops': 3,
    'vehicleNo': 'MH 04 KF 8821',
    'driverName': 'Ramesh Yadav',
    'customer': 'Shree Balaji FMCG',
    'status': 'running',
    'gps': 'live',
    'eta': _t(const Duration(hours: 9)).toIso8601String(),
    'progress': 0.62,
    'freight': 86500,
    'cost': 71200,
    'ownFleet': true,
  },
  {
    'id': 'TRP-24869',
    'origin': 'Pune, MH',
    'destination': 'Bengaluru, KA',
    'stops': 2,
    'vehicleNo': 'MH 12 RT 4410',
    'driverName': 'Sandeep Patil',
    'customer': 'Kaveri Auto Components',
    'status': 'delayed',
    'gps': 'delayed',
    'eta': _t(const Duration(hours: 3, minutes: 40)).toIso8601String(),
    'progress': 0.81,
    'freight': 64000,
    'cost': 55800,
    'ownFleet': true,
  },
  {
    'id': 'TRP-24866',
    'origin': 'Ludhiana, PB',
    'destination': 'Jaipur, RJ',
    'stops': 1,
    'vehicleNo': 'PB 10 GH 7392',
    'driverName': 'Gurpreet Singh',
    'customer': 'Oswal Textiles',
    'status': 'delayed',
    'gps': 'stale',
    'eta': _t(const Duration(hours: -1, minutes: -20)).toIso8601String(),
    'progress': 0.9,
    'freight': 48500,
    'cost': 41300,
    'ownFleet': false,
  },
  {
    'id': 'TRP-24862',
    'origin': 'Chennai, TN',
    'destination': 'Hyderabad, TS',
    'stops': 2,
    'vehicleNo': 'TN 09 CD 2287',
    'driverName': 'Murugan K',
    'customer': 'Sundaram Pharma Distributors',
    'status': 'running',
    'gps': 'live',
    'eta': _t(const Duration(hours: 14)).toIso8601String(),
    'progress': 0.34,
    'freight': 72000,
    'cost': 60400,
    'ownFleet': true,
  },
  {
    'id': 'TRP-24858',
    'origin': 'Kolkata, WB',
    'destination': 'Patna, BR',
    'stops': 1,
    'vehicleNo': 'WB 24 AB 9034',
    'driverName': 'Biswajit Das',
    'customer': 'Eastern Steel Traders',
    'status': 'running',
    'gps': 'noDevice',
    'eta': _t(const Duration(hours: 6, minutes: 30)).toIso8601String(),
    'progress': 0.7,
    'freight': 39500,
    'cost': 33100,
    'ownFleet': false,
  },
];

final List<Map<String, dynamic>> _vehicleMaps = [
  {
    'id': 'VEH-101',
    'regNo': 'MH 04 KF 8821',
    'type': '32 ft Multi-Axle',
    'capacity': '18 T',
    'status': 'On trip',
    'gps': 'live',
    'location': 'Near Indore Bypass, MP',
    'ownFleet': true,
    'vendor': null,
    'imageUrl':
        'https://images.unsplash.com/photo-1600539872165-83c2bea969b9',
    'semanticLabel':
        'White 32 foot multi axle cargo truck parked on a highway shoulder under a clear blue sky',
  },
  {
    'id': 'VEH-114',
    'regNo': 'GJ 06 XY 1175',
    'type': '20 ft Container',
    'capacity': '9 T',
    'status': 'Available',
    'gps': 'live',
    'location': 'Ahmedabad Transport Nagar, GJ',
    'ownFleet': true,
    'vendor': null,
    'imageUrl':
        'https://images.unsplash.com/photo-1690661452652-84b3711d771e',
    'semanticLabel':
        'Blue container truck in a logistics yard with stacked shipping containers behind it',
  },
  {
    'id': 'VEH-208',
    'regNo': 'RJ 14 GB 5530',
    'type': 'Open 24 ft',
    'capacity': '14 T',
    'status': 'Available',
    'gps': 'stale',
    'location': 'Jaipur Sitapura, RJ',
    'ownFleet': false,
    'vendor': 'Marwar Roadlines',
    'imageUrl':
        'https://images.unsplash.com/photo-1704717576555-8a5178fa52c4',
    'semanticLabel':
        'Orange open body goods truck loaded with sacks standing on a dusty roadside in daylight',
  },
];

final List<Map<String, dynamic>> _bidMaps = [
  {
    'id': 'BID-7712',
    'lane': 'Bhiwandi to Gurugram',
    'material': 'FMCG cartons',
    'weight': '16 T',
    'ourBid': 78000,
    'leadingBid': 76500,
    'bidders': 7,
    'closesAt': _t(const Duration(minutes: 42)).toIso8601String(),
    'status': 'expiring',
  },
  {
    'id': 'BID-7709',
    'lane': 'Surat to Kolkata',
    'material': 'Textile rolls',
    'weight': '12 T',
    'ourBid': 112000,
    'leadingBid': 112000,
    'bidders': 4,
    'closesAt': _t(const Duration(hours: 3, minutes: 15)).toIso8601String(),
    'status': 'open',
  },
  {
    'id': 'BID-7704',
    'lane': 'Nagpur to Hyderabad',
    'material': 'Cement bags',
    'weight': '22 T',
    'ourBid': 46500,
    'leadingBid': 44000,
    'bidders': 9,
    'closesAt': _t(const Duration(hours: 6)).toIso8601String(),
    'status': 'open',
  },
];

final List<Map<String, dynamic>> _loadMaps = [
  {
    'id': 'LD-55120',
    'customer': 'Reliant Retail Pvt Ltd',
    'origin': 'Mundra Port, GJ',
    'destination': 'Delhi NCR',
    'material': 'Electronics',
    'weight': '10 T',
    'vehicleType': '32 ft Single Axle',
    'pickup': _t(const Duration(days: 1, hours: 3)).toIso8601String(),
    'budget': 92000,
  },
  {
    'id': 'LD-55118',
    'customer': 'Himalaya Agro Foods',
    'origin': 'Nashik, MH',
    'destination': 'Lucknow, UP',
    'material': 'Packaged onions',
    'weight': '18 T',
    'vehicleType': '24 ft Open',
    'pickup': _t(const Duration(days: 2)).toIso8601String(),
    'budget': null,
  },
];

final List<Map<String, dynamic>> _timelineMaps = [
  {
    'title': 'Loaded at Bhiwandi',
    'subtitle': 'Gate pass GP-8821 verified',
    'at': _t(const Duration(hours: -14)).toIso8601String(),
    'done': true,
  },
  {
    'title': 'Departed Bhiwandi hub',
    'subtitle': 'Odometer 214,880 km',
    'at': _t(const Duration(hours: -13, minutes: -10)).toIso8601String(),
    'done': true,
  },
  {
    'title': 'Crossed Gujarat border',
    'subtitle': 'e-way bill valid till tomorrow',
    'at': _t(const Duration(hours: -7)).toIso8601String(),
    'done': true,
  },
  {
    'title': 'Halt at Udaipur',
    'subtitle': 'Driver rest, 45 min',
    'at': _t(const Duration(hours: -1)).toIso8601String(),
    'done': false,
    'current': true,
  },
  {
    'title': 'Delivery at Gurugram',
    'subtitle': 'Shree Balaji FMCG warehouse',
    'at': _t(const Duration(hours: 9)).toIso8601String(),
    'done': false,
  },
];

final List<Map<String, dynamic>> _kpiMaps = [
  {
    'id': 'active_trips',
    'label': 'Active trips',
    'value': '23',
    'trend': '+4 vs yesterday',
    'trendPositive': true,
  },
  {
    'id': 'available_vehicles',
    'label': 'Available vehicles',
    'value': '9',
    'trend': '3 market, 6 own',
    'trendPositive': true,
  },
  {
    'id': 'open_bids',
    'label': 'Open bids',
    'value': '14',
    'trend': '2 closing in 1 hr',
    'trendPositive': false,
    'alert': true,
  },
  {
    'id': 'pending_pods',
    'label': 'Pending PODs',
    'value': '6',
    'trend': '2 rejected',
    'trendPositive': false,
    'alert': true,
  },
  {
    'id': 'revenue',
    'label': 'Revenue (MTD)',
    'value': '₹48,62,500',
    'trend': '+8% vs last month',
    'trendPositive': true,
    'financial': true,
  },
  {
    'id': 'margin',
    'label': 'Margin (MTD)',
    'value': '11.4%',
    'trend': '-0.6 pts vs last month',
    'trendPositive': false,
    'financial': true,
  },
];

final List<Map<String, dynamic>> _attentionMaps = [
  {
    'title': 'Trips running late',
    'detail': 'TRP-24866 is 1 hr 20 min behind and GPS is stale',
    'count': 2,
  },
  {
    'title': 'Bids closing soon',
    'detail': 'Bhiwandi to Gurugram closes in 42 min',
    'count': 2,
  },
  {
    'title': 'PODs rejected',
    'detail': 'Blurry LR copy on TRP-24840 needs re-upload',
    'count': 2,
  },
];

final List<Map<String, dynamic>> _weeklyMaps = [
  {'day': 'Wed', 'completed': 14, 'delayed': 2},
  {'day': 'Thu', 'completed': 17, 'delayed': 3},
  {'day': 'Fri', 'completed': 19, 'delayed': 1},
  {'day': 'Sat', 'completed': 12, 'delayed': 4},
  {'day': 'Sun', 'completed': 9, 'delayed': 1},
  {'day': 'Mon', 'completed': 18, 'delayed': 2},
  {'day': 'Tue', 'completed': 16, 'delayed': 5},
];

final Map<String, dynamic> _gpsMap = {
  'live': 31,
  'delayed': 4,
  'stale': 3,
  'noDevice': 2,
};

final Map<String, dynamic> _profileMap = {
  'companyName': 'Vardhman Roadways Pvt Ltd',
  'userName': 'Anil Vardhman',
  'email': 'anil@vardhmanroadways.in',
  'gstin': '27AABCV4521M1Z8',
  'city': 'Bhiwandi, Maharashtra',
};

class MockDashboardRepository implements DashboardRepository {
  @override
  Future<DashboardData> loadDashboard() async {
    return DashboardData(
      companyName: 'Vardhman Roadways',
      updatedAt: DateTime.now(),
      kpis: _kpiMaps.map(Kpi.fromMap).toList(),
      attention: _attentionMaps.map(AttentionItem.fromMap).toList(),
      activeTrips: _tripMaps.map(Trip.fromMap).toList(),
      closingBids: _bidMaps.map(Bid.fromMap).toList(),
      weekly: _weeklyMaps.map(DayTrips.fromMap).toList(),
      gps: GpsSummary.fromMap(_gpsMap),
    );
  }
}

class MockSampleComponentRepository implements SampleComponentRepository {
  @override
  Future<List<Trip>> sampleTrips() async =>
      _tripMaps.map(Trip.fromMap).toList();

  @override
  Future<List<Vehicle>> sampleVehicles() async =>
      _vehicleMaps.map(Vehicle.fromMap).toList();

  @override
  Future<List<Bid>> sampleBids() async => _bidMaps.map(Bid.fromMap).toList();

  @override
  Future<List<LoadItem>> sampleLoads() async =>
      _loadMaps.map(LoadItem.fromMap).toList();

  @override
  Future<List<TimelineItem>> sampleTimeline() async =>
      _timelineMaps.map(TimelineItem.fromMap).toList();
}

class MockProfileRepository implements ProfileRepository {
  @override
  Future<CompanyProfile> loadProfile() async =>
      CompanyProfile.fromMap(_profileMap);
}

/// Single place that decides which implementation the app uses.
// TODO: Replace with Riverpod providers when real repositories exist
class Repos {
  Repos._();

  static DashboardRepository get dashboard {
    // A real implementation would be returned when USE_MOCK_DATA is false.
    if (USE_MOCK_DATA) return MockDashboardRepository();
    return MockDashboardRepository();
  }

  static SampleComponentRepository get samples =>
      MockSampleComponentRepository();

  static ProfileRepository get profile => MockProfileRepository();
}
