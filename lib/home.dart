import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'DiseaseDetector.dart';
import 'Weather.dart';
import 'soon.dart';
import 'SettingsProvider.dart';
import 'Settings.dart';
import 'TreatmentRecommendations.dart';
import 'PlantCare.dart';
import 'FertilizerCalculator.dart';
import 'FertilizerMarket.dart';
import 'MarketConnect.dart';
import 'SoilHealthAnalysis.dart';
import 'FarmActivityLog.dart';
import 'FinancialManagement.dart';
import 'ExpertConsultation.dart';
import 'ChatbotScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  List<FeatureItem> getFeatures(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      FeatureItem(icon: Icons.bug_report, title: l10n.diseaseDetection),

      FeatureItem(icon: Icons.healing, title: l10n.treatmentRecommendations),
      FeatureItem(icon: Icons.support_agent, title: l10n.expertConsultation),
      FeatureItem(icon: Icons.calculate, title: l10n.fertilizerCalculator),
      FeatureItem(icon: Icons.eco, title: l10n.plantCareTips),
      FeatureItem(icon: Icons.shopping_cart, title: l10n.buyingFertilizers),
      FeatureItem(icon: Icons.store, title: l10n.marketConnect),
      FeatureItem(icon: Icons.landscape, title: l10n.soilHealthAnalysis),
      FeatureItem(icon: Icons.cloud, title: l10n.weatherForecast),
      FeatureItem(icon: Icons.event_note, title: l10n.farmActivityLog),
      FeatureItem(icon: Icons.account_balance_wallet, title: l10n.financialManagement),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Scaffold(
          body: CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 150.0,
                floating: false,
                pinned: true,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    var top = constraints.biggest.height;
                    return FlexibleSpaceBar(
                      titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                      title: Text(
                        l10n.appTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                            child: Image.asset(
                              'assets/bg.jpeg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(_getOpacity()),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                backgroundColor: Colors.green,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                ),
                actions: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                    ),
                  ),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      return FeatureCard(feature: getFeatures(context)[index]);
                    },
                    childCount: getFeatures(context).length,
                  ),
                ),
              ),
            ],
          ),
          endDrawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.green,
                  ),
                  child: Text(
                    l10n.drawerTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: Text(l10n.settings),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(l10n.profile),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ComingSoonScreen(title: 'Profile',)));
                  },
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ChatbotScreen()),
              );
            },
            child: const Icon(Icons.chat),
            tooltip: l10n.openChatbot,
          ),
        );
      },
    );
  }

  double _getOpacity() {
    const double startOffset = 0;
    const double endOffset = 100;

    if (_scrollOffset <= startOffset) return 0.0;
    if (_scrollOffset >= endOffset) return 1.0;

    return (_scrollOffset - startOffset) / (endOffset - startOffset);
  }
}

class FeatureCard extends StatelessWidget {
  final FeatureItem feature;

  const FeatureCard({super.key, required this.feature});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          if (feature.title == 'Disease Detection') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DiseaseDetector()),
            );
          }else if (feature.title == 'Weather Forecast') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WeatherScreen()),
            );
          }
          else if(feature.title=='Treatment Recommendations'){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TreatmentRecommendations()),
            );
          }
          else if(feature.title=='Plant Care Tips'){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PlantCareTips()),
            );
          }
          else if(feature.title=='Fertilizer Calculator'){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FertilizerQuantityCalculator()),
            );
          }
          else if(feature.title=='Buying Fertilizers'){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FertilizerStoreScreen()),
            );
          }
          else if(feature.title=='Market Connect'){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MarketConnectScreen()),
            );
          }
          else if(feature.title=='Expert Consultation'){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) =>  const ExpertConsultation()),
            );
          }
          else if(feature.title=='Soil Health Analysis'){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SoilHealthAnalysis()),
            );
          }
          else if(feature.title=='Financial Management'){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) =>  const FinancialManagement()),
            );
          }
          else if(feature.title=='Farm Activity Log'){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FarmActivityLog()),
            );
          }
          else {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ComingSoonScreen(title: 'Coming Soon',)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(feature.icon, size: 40, color: Colors.green),
              const SizedBox(height: 8),
              Text(
                feature.title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureItem {
  final IconData icon;
  final String title;

  FeatureItem({required this.icon, required this.title});
}