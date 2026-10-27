import 'package:flutter/foundation.dart';

enum GpsFreshness { live, delayed, stale, noDevice }

enum TripStatus { planned, running, delayed, completed, cancelled }

enum BidStatus { open, won, lost, expiring }

enum DocStatus { idle, uploading, success, failed, rejected }

GpsFreshness _gpsFrom(String v) {
  switch (v) {
    case 'live':
      return GpsFreshness.live;
    case 'delayed':
      return GpsFreshness.delayed;
    case 'stale':
      return GpsFreshness.stale;
    default:
      return GpsFreshness.noDevice;
  }
}

TripStatus _tripStatusFrom(String v) {
  switch (v) {
    case 'planned':
      return TripStatus.planned;
    case 'delayed':
      return TripStatus.delayed;
    case 'completed':
      return TripStatus.completed;
    case 'cancelled':
      return TripStatus.cancelled;
    default:
      return TripStatus.running;
  }
}

BidStatus _bidStatusFrom(String v) {
  switch (v) {
    case 'won':
      return BidStatus.won;
    case 'lost':
      return BidStatus.lost;
    case 'expiring':
      return BidStatus.expiring;
    default:
      return BidStatus.open;
  }
}

@immutable
class Kpi {
  final String id;
  final String label;
  final String value;
  final String? trend; // e.g. "+8% vs last week"
  final bool trendPositive;
  final bool financial;
  final bool alert;

  const Kpi({
    required this.id,
    required this.label,
    required this.value,
    this.trend,
    this.trendPositive = true,
    this.financial = false,
    this.alert = false,
  });

  factory Kpi.fromMap(Map<String, dynamic> m) => Kpi(
    id: m['id'] as String,
    label: m['label'] as String,
    value: m['value'] as String,
    trend: m['trend'] as String?,
    trendPositive: (m['trendPositive'] as bool?) ?? true,
    financial: (m['financial'] as bool?) ?? false,
    alert: (m['alert'] as bool?) ?? false,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'label': label,
    'value': value,
    'trend': trend,
    'trendPositive': trendPositive,
    'financial': financial,
    'alert': alert,
  };
}

@immutable
class Trip {
  final String id;
  final String origin;
  final String destination;
  final int stops;
  final String vehicleNo;
  final String driverName;
  final String customer;
  final TripStatus status;
  final GpsFreshness gps;
  final DateTime eta;
  final double progress; // 0..1
  final num freight;
  final num cost;
  final bool ownFleet;

  const Trip({
    required this.id,
    required this.origin,
    required this.destination,
    required this.stops,
    required this.vehicleNo,
    required this.driverName,
    required this.customer,
    required this.status,
    required this.gps,
    required this.eta,
    required this.progress,
    required this.freight,
    required this.cost,
    required this.ownFleet,
  });

  factory Trip.fromMap(Map<String, dynamic> m) => Trip(
    id: m['id'] as String,
    origin: m['origin'] as String,
    destination: m['destination'] as String,
    stops: (m['stops'] as num).toInt(),
    vehicleNo: m['vehicleNo'] as String,
    driverName: m['driverName'] as String,
    customer: m['customer'] as String,
    status: _tripStatusFrom(m['status'] as String),
    gps: _gpsFrom(m['gps'] as String),
    eta: DateTime.parse(m['eta'] as String),
    progress: (m['progress'] as num).toDouble(),
    freight: m['freight'] as num,
    cost: m['cost'] as num,
    ownFleet: m['ownFleet'] as bool,
  );
}

@immutable
class Vehicle {
  final String id;
  final String regNo;
  final String type;
  final String capacity;
  final String status; // available / on trip / maintenance
  final GpsFreshness gps;
  final String location;
  final bool ownFleet;
  final String? vendor;
  final String? imageUrl;
  final String imageLabel;

  const Vehicle({
    required this.id,
    required this.regNo,
    required this.type,
    required this.capacity,
    required this.status,
    required this.gps,
    required this.location,
    required this.ownFleet,
    this.vendor,
    this.imageUrl,
    required this.imageLabel,
  });

  factory Vehicle.fromMap(Map<String, dynamic> m) => Vehicle(
    id: m['id'] as String,
    regNo: m['regNo'] as String,
    type: m['type'] as String,
    capacity: m['capacity'] as String,
    status: m['status'] as String,
    gps: _gpsFrom(m['gps'] as String),
    location: m['location'] as String,
    ownFleet: m['ownFleet'] as bool,
    vendor: m['vendor'] as String?,
    imageUrl: m['imageUrl'] as String?,
    imageLabel: m['semanticLabel'] as String,
  );
}

@immutable
class Bid {
  final String id;
  final String lane;
  final String material;
  final String weight;
  final num ourBid;
  final num? leadingBid;
  final int bidders;
  final DateTime closesAt;
  final BidStatus status;

  const Bid({
    required this.id,
    required this.lane,
    required this.material,
    required this.weight,
    required this.ourBid,
    required this.leadingBid,
    required this.bidders,
    required this.closesAt,
    required this.status,
  });

  factory Bid.fromMap(Map<String, dynamic> m) => Bid(
    id: m['id'] as String,
    lane: m['lane'] as String,
    material: m['material'] as String,
    weight: m['weight'] as String,
    ourBid: m['ourBid'] as num,
    leadingBid: m['leadingBid'] as num?,
    bidders: (m['bidders'] as num).toInt(),
    closesAt: DateTime.parse(m['closesAt'] as String),
    status: _bidStatusFrom(m['status'] as String),
  );
}

@immutable
class LoadItem {
  final String id;
  final String customer;
  final String origin;
  final String destination;
  final String material;
  final String weight;
  final String vehicleType;
  final DateTime pickup;
  final num? budget;

  const LoadItem({
    required this.id,
    required this.customer,
    required this.origin,
    required this.destination,
    required this.material,
    required this.weight,
    required this.vehicleType,
    required this.pickup,
    this.budget,
  });

  factory LoadItem.fromMap(Map<String, dynamic> m) => LoadItem(
    id: m['id'] as String,
    customer: m['customer'] as String,
    origin: m['origin'] as String,
    destination: m['destination'] as String,
    material: m['material'] as String,
    weight: m['weight'] as String,
    vehicleType: m['vehicleType'] as String,
    pickup: DateTime.parse(m['pickup'] as String),
    budget: m['budget'] as num?,
  );
}

@immutable
class TimelineItem {
  final String title;
  final String subtitle;
  final DateTime at;
  final bool done;
  final bool current;

  const TimelineItem({
    required this.title,
    required this.subtitle,
    required this.at,
    required this.done,
    this.current = false,
  });

  factory TimelineItem.fromMap(Map<String, dynamic> m) => TimelineItem(
    title: m['title'] as String,
    subtitle: m['subtitle'] as String,
    at: DateTime.parse(m['at'] as String),
    done: m['done'] as bool,
    current: (m['current'] as bool?) ?? false,
  );
}

@immutable
class AttentionItem {
  final String title;
  final String detail;
  final int count;

  const AttentionItem({
    required this.title,
    required this.detail,
    required this.count,
  });

  factory AttentionItem.fromMap(Map<String, dynamic> m) => AttentionItem(
    title: m['title'] as String,
    detail: m['detail'] as String,
    count: (m['count'] as num).toInt(),
  );
}

@immutable
class DayTrips {
  final String day;
  final int completed;
  final int delayed;
  const DayTrips({
    required this.day,
    required this.completed,
    required this.delayed,
  });

  factory DayTrips.fromMap(Map<String, dynamic> m) => DayTrips(
    day: m['day'] as String,
    completed: (m['completed'] as num).toInt(),
    delayed: (m['delayed'] as num).toInt(),
  );
}

@immutable
class GpsSummary {
  final int live;
  final int delayed;
  final int stale;
  final int noDevice;
  const GpsSummary({
    required this.live,
    required this.delayed,
    required this.stale,
    required this.noDevice,
  });

  factory GpsSummary.fromMap(Map<String, dynamic> m) => GpsSummary(
    live: (m['live'] as num).toInt(),
    delayed: (m['delayed'] as num).toInt(),
    stale: (m['stale'] as num).toInt(),
    noDevice: (m['noDevice'] as num).toInt(),
  );
}

@immutable
class DashboardData {
  final String companyName;
  final DateTime updatedAt;
  final List<Kpi> kpis;
  final List<AttentionItem> attention;
  final List<Trip> activeTrips;
  final List<Bid> closingBids;
  final List<DayTrips> weekly;
  final GpsSummary gps;

  const DashboardData({
    required this.companyName,
    required this.updatedAt,
    required this.kpis,
    required this.attention,
    required this.activeTrips,
    required this.closingBids,
    required this.weekly,
    required this.gps,
  });
}

@immutable
class CompanyProfile {
  final String companyName;
  final String userName;
  final String email;
  final String gstin;
  final String city;
  const CompanyProfile({
    required this.companyName,
    required this.userName,
    required this.email,
    required this.gstin,
    required this.city,
  });

  factory CompanyProfile.fromMap(Map<String, dynamic> m) => CompanyProfile(
    companyName: m['companyName'] as String,
    userName: m['userName'] as String,
    email: m['email'] as String,
    gstin: m['gstin'] as String,
    city: m['city'] as String,
  );
}
