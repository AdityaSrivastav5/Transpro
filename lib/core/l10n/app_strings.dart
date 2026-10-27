
/// All user-visible strings. English now; add a Hindi map and switch on locale later.
// TODO: Replace with flutter_localizations + ARB files when Hindi is added
class Strings {
  Strings._();

  static const String appName = 'TransPro';

  // Navigation
  static const String navHome = 'Home';
  static const String navLoads = 'Loads & Bids';
  static const String navTrips = 'Trips';
  static const String navFleet = 'Fleet';
  static const String navMore = 'More';

  // Home
  static const String homeTitle = 'Operations';
  static const String needsAttention = 'Needs attention';
  static const String kpiActiveTrips = 'Active trips';
  static const String kpiAvailableVehicles = 'Available vehicles';
  static const String kpiOpenBids = 'Open bids';
  static const String kpiPendingPods = 'Pending PODs';
  static const String kpiRevenueMtd = 'Revenue (MTD)';
  static const String kpiMargin = 'Margin (MTD)';
  static const String activeTrips = 'Active trips';
  static const String bidsClosingSoon = 'Bids closing soon';
  static const String gpsHealth = 'GPS health';
  static const String weeklyTrips = 'Trips this week';
  static const String postLoad = 'Post Load';
  static const String seeAll = 'See all';
  static const String lastUpdated = 'Updated';
  static const String roleRestricted = 'Hidden for your role';

  // More
  static const String moreSubcontractors = 'Subcontractors';
  static const String moreDocuments = 'Documents';
  static const String moreReceivables = 'Receivables';
  static const String moreExpenses = 'Expenses';
  static const String moreReports = 'Reports';
  static const String moreNotifications = 'Notifications';
  static const String moreProfile = 'Profile & Company';
  static const String moreSettings = 'Settings';
  static const String moreHelp = 'Help';
  static const String moreLogout = 'Logout';
  static const String comingSoon = 'Coming soon';

  // Settings
  static const String settingsTitle = 'Settings';
  static const String sectionAccount = 'Account';
  static const String sectionDeveloper = 'Developer only';
  static const String sectionPreferences = 'Preferences';
  static const String sectionNotifications = 'Notifications';
  static const String sectionDanger = 'Danger zone';
  static const String roleSwitcher = 'Role switcher';
  static const String roleSwitcherHint =
      'Changes what each screen shows. Not visible in production.';
  static const String language = 'Language';
  static const String languageEnglish = 'English';
  static const String languageHindi = 'हिन्दी';
  static const String mockDataFlag = 'USE_MOCK_DATA';
  static const String componentGallery = 'Component gallery';
  static const String componentGalleryHint =
      'Every reusable component, every state';
  static const String notifBids = 'Bid updates';
  static const String notifTrips = 'Trip delays and alerts';
  static const String notifDocs = 'Document rejections';
  static const String logout = 'Log out';
  static const String logoutConfirmTitle = 'Log out of TransPro?';
  static const String logoutConfirmBody =
      'You will need to sign in again to see your fleet and trips.';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';

  // Generic states
  static const String retry = 'Try again';
  static const String offlineBanner =
      'You are offline. Showing last saved data.';
  static const String emptyTitle = 'Nothing here yet';
  static const String errorTitle = 'Could not load this';
  static const String errorBody = 'Check your connection and try again.';

  // Documents
  static const String uploadIdle = 'Tap to upload';
  static const String uploading = 'Uploading';
  static const String uploadSuccess = 'Uploaded';
  static const String uploadFailed = 'Upload failed';
  static const String uploadRejected = 'Rejected';

  // GPS
  static const String gpsLive = 'Live';
  static const String gpsDelayed = 'Delayed';
  static const String gpsStale = 'Stale';
  static const String gpsNoDevice = 'No device';
}
