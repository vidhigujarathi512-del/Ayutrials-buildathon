import 'package:flutter/material.dart';

void main() => runApp(const EquiMatchApp());

class EquiMatchApp extends StatelessWidget {
  const EquiMatchApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF0F172A),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      home: const DemoWorkspaceScreen(),
    );
  }
}

class DemoWorkspaceScreen extends StatefulWidget {
  const DemoWorkspaceScreen({Key? key}) : super(key: key);
  @override
  State<DemoWorkspaceScreen> createState() => _DemoWorkspaceScreenState();
}

class _DemoWorkspaceScreenState extends State<DemoWorkspaceScreen> {
  int currentStep = 1;
  String selectedLanguage = "English";
  
  // Custom interactive paste controller
  final _protocolInputController = TextEditingController(
    text: "Patients aged 18-60\nHbA1c between 7 and 9\nNot pregnant",
  );

  // Flashcard Page Stack State Controllers
  int activeFlashcardIndex = 0;
  final _ageController = TextEditingController(text: "25");
  final _hba1cController = TextEditingController(text: "8.0");
  bool _hasDiabetes = true;
  bool _isPregnant = false;

  // Evaluated Engine States
  int runtimeScore = 100;
  List<Map<String, dynamic>> dynamicChecklist = [];

  void _calculateMetricsLocally() {
    int parsedAge = int.tryParse(_ageController.text) ?? 25;
    double parsedHbA1c = double.tryParse(_hba1cController.text) ?? 8.0;

    bool ageValid = parsedAge >= 18 && parsedAge <= 60;
    bool hba1cValid = parsedHbA1c >= 7.0 && parsedHbA1c <= 9.0;
    bool diabetesValid = _hasDiabetes == true;
    bool pregnancyValid = _isPregnant == false;

    int computedScore = 0;
    if (ageValid) computedScore += 25;
    if (hba1cValid) computedScore += 25;
    if (diabetesValid) computedScore += 25;
    if (pregnancyValid) computedScore += 25;

    setState(() {
      runtimeScore = computedScore;
      dynamicChecklist = [
        {"pass": ageValid, "text": "Age Requirement ${ageValid ? 'Met' : 'Not Met'}"},
        {"pass": hba1cValid, "text": "HbA1c Requirement ${hba1cValid ? 'Met' : 'Not Met'}"},
        {"pass": diabetesValid, "text": "Type 2 Diabetes Requirement ${diabetesValid ? 'Met' : 'Not Met'}"},
        {"pass": pregnancyValid, "text": "Pregnancy Requirement ${pregnancyValid ? 'Met' : 'Not Met'}"}
      ];
      currentStep = 5;
      activeFlashcardIndex = 0;
  });
  }

  @override
  Widget build(BuildContext context) {
    // Check width to see if we are on a desktop browser or phone screen layout
    bool isWideScreen = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      appBar: AppBar(
        title: const Text("EquiMatch // Live Demo Dashboard", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF0F172A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      // Mobile Feature: Hidden Drawer menu triggered on small phone displays
      drawer: !isWideScreen ? Drawer(
        child: Container(
          color: const Color(0xFF1E293B),
          child: _buildSidebarContent(),
        ),
      ) : null,
      body: Row(
        children: [
          // Desktop view configuration: Render stable sidebar panel if wide layout
          if (isWideScreen)
            Container(
              width: 280,
              color: const Color(0xFF1E293B),
              child: _buildSidebarContent(),
            ),
          
          // Main core workspace display pane window mapping
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _renderActiveStepWorkspace(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Extracted helper logic to clean rendering panels blocks
  Widget _buildSidebarContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text("PRESENTATION PANEL", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          const SizedBox(height: 20),
          _buildSidebarButton(1, "Upload Trial Protocol"),
          _buildSidebarButton(2, "Accessibility Analysis"),
          _buildSidebarButton(3, "Plain Language Summary"),
          _buildSidebarButton(4, "Patient Eligibility Check"),
          _buildSidebarButton(5, "Eligibility Results"),
          _buildSidebarButton(6, "Audio Consent Summary"),
          const Spacer(),
          const Divider(color: Colors.white24),
          const Text("ROADMAP METRICS", style: TextStyle(color: Colors.cyan, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text("• HIPAA & DPDP Compliant Token Strings\n• Real-Time Haversine Distance Filters", style: TextStyle(color: Colors.white54, fontSize: 11, height: 1.4)),
        ],
      ),
    );
  }

  Widget _buildSidebarButton(int step, String text) {
    bool isActive = currentStep == step;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isActive ? Colors.blueAccent : const Color(0xFF0F172A),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            setState(() => currentStep = step);
            // Programmatically close drawer view if clicked inside phone UI environment
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          child: Text("$step. $text", style: TextStyle(color: isActive ? Colors.white : Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }

  Widget _renderActiveStepWorkspace() {
    switch (currentStep) {
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Upload Trial Protocol Node", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text("Simulate dynamic clinical ingestion by updating or pasting raw text constraints below.", style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _protocolInputController,
                maxLines: null,
                minLines: null,
                expands: true,
                style: const TextStyle(fontFamily: 'Courier', fontSize: 13, color: Colors.blueGrey),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  hintText: "Paste raw medical guidelines criteria here...",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A)),
                onPressed: () {
                  setState(() => currentStep = 2);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Protocol metrics scanned and updated securely.")),
                  );
                },
                child: const Text("Analyze Guidelines", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        );

      case 2:
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Accessibility Analysis Engine Breakdown", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildMetricsTile("Flesch Ease Indicator", "38 / 100", Colors.redAccent, "High Complexity jargon match parameters flagged"),
              const SizedBox(height: 12),
              _buildMetricsTile("SMOG Index Score", "Grade 14+", Colors.orange, "Requires postgraduate literacy baseline comprehension"),
              const SizedBox(height: 12),
              _buildMetricsTile("Jargon Term Concentration", "18.4%", Colors.amber.shade700, "High density clinical phrases checked"),
              const SizedBox(height: 12),
              _buildMetricsTile("Average Syntax Length", "28.3 words", Colors.blue, "Long string structures disrupt consumer parsing"),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.red.shade200)),
                child: const Row(
                  children: [
                    Icon(Icons.gpp_bad, color: Colors.red),
                    SizedBox(width: 12),
                    Expanded(child: Text("Recruitment Impact Notice: High vocabulary friction detected. Diversity channel acquisition likelihood reduced by 65%.", style: TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w600))),
                  ],
                ),
              )
            ],
          ),
        );

      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Plain Language Summary Generation Hub", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ["English", "Hindi", "Marathi"].map((l) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(l),
                      selected: selectedLanguage == l,
                      onSelected: (selected) {
                        if (selected) setState(() => selectedLanguage = l);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(16)),
                child: SingleChildScrollView(
                  child: Text(_fetchBrandedLanguageOutput(), style: const TextStyle(fontSize: 15, height: 1.5, color: Color(0xFF0F172A), fontWeight: FontWeight.w500)),
                ),
              ),
            )
          ],
        );

      case 4: 
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Patient Eligibility Check", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text("Progress tracking block: Card ${activeFlashcardIndex + 1} of 4", style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: double.infinity,
                    height: 220,
                    child: Card(
                      color: Colors.blueGrey.shade900,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _renderActiveFlashcardSegment(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: activeFlashcardIndex == 0 ? null : () => setState(() => activeFlashcardIndex--),
                  child: const Text("Previous"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A)),
                  onPressed: () {
                    if (activeFlashcardIndex < 3) {
                      setState(() => activeFlashcardIndex++);
                    } else {
                      _calculateMetricsLocally();
                    }
                  },
                  child: Text(activeFlashcardIndex == 3 ? "Submit" : "Next"),
                )
              ],
            )
          ],
        );

      case 5: 
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Eligibility Results", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: runtimeScore == 100 ? Colors.green.shade100 : (runtimeScore >= 50 ? Colors.orange.shade100 : Colors.red.shade100), 
                    shape: BoxShape.circle
                  ),
                  child: Text("$runtimeScore%", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: runtimeScore == 100 ? Colors.green : (runtimeScore >= 50 ? Colors.orange : Colors.red))),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Eligibility Score: $runtimeScore%", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const Text("Token profile: AGE_XX_DIABETES_XX", style: TextStyle(fontFamily: 'Courier', color: Colors.blueGrey, fontSize: 11)),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            const Text("CRITERIA VERIFICATION CHECKS", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.1)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: dynamicChecklist.isEmpty ? 4 : dynamicChecklist.length,
                itemBuilder: (context, idx) {
                  bool isPass = dynamicChecklist.isEmpty ? true : dynamicChecklist[idx]["pass"];
                  String displayMessage = dynamicChecklist.isEmpty 
                    ? ["Age Requirement Met", "HbA1c Requirement Met", "Type 2 Diabetes Requirement Met", "Pregnancy Requirement Met"][idx]
                    : dynamicChecklist[idx]["text"];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Icon(isPass ? Icons.check : Icons.close, color: isPass ? Colors.green : Colors.red, size: 18),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "${isPass ? '✓' : '✗'} $displayMessage", 
                            style: TextStyle(fontSize: 14, fontWeight: isPass ? FontWeight.normal : FontWeight.bold, color: isPass ? Colors.black87 : Colors.red.shade900)
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 16),
            const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 18),
                SizedBox(width: 8),
                Expanded(child: Text("Geospatial Alert: Trial facility commute is 70 km.", style: TextStyle(fontSize: 12, color: Colors.blueGrey))),
              ],
            )
          ],
        );

      case 6:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(child: Icon(Icons.record_voice_over, size: 64, color: Colors.blueAccent)),
            const SizedBox(height: 16),
            const Text("Audio Consent Summary", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Streaming 60-second summary matched to language format: $selectedLanguage", textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Playing audio summary context capsule in $selectedLanguage...")),
                );
              },
              icon: const Icon(Icons.play_circle_filled, color: Colors.white),
              label: const Text("Play Consent Audio", style: TextStyle(color: Colors.white)),
            )
          ],
        );

      default:
        return const Center(child: Text("State Mapping Invalidation Exception"));
    }
  }

  Widget _buildMetricsTile(String label, String value, Color color, String description) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.blueGrey, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(description, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _renderActiveFlashcardSegment() {
    switch (activeFlashcardIndex) {
      case 0:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cake, color: Colors.cyan, size: 28),
            const SizedBox(height: 8),
            const Text("Parameter 1: Operational Age Bounds", style: TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 4),
            TextField(
              controller: _ageController,
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(border: InputBorder.none, hintText: "Enter Age", hintStyle: TextStyle(color: Colors.white24)),
            )
          ],
        );
      case 1:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bloodtype, color: Colors.redAccent, size: 28),
            const SizedBox(height: 8),
            const Text("Parameter 2: Lab Ingestion HbA1c Levels", style: TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 4),
            TextField(
              controller: _hba1cController,
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(border: InputBorder.none, hintText: "Enter Value", hintStyle: TextStyle(color: Colors.white24)),
            )
          ],
        );
      case 2:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.medical_services, color: Colors.greenAccent, size: 28),
            const SizedBox(height: 8),
            const Text("Parameter 3: Diagnosed with Type 2 Diabetes?", style: TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 4),
            Switch(
              value: _hasDiabetes,
              activeTrackColor: Colors.greenAccent.withAlpha((0.4 * 255).round()),
              activeThumbColor: Colors.greenAccent,
              onChanged: (val) => setState(() => _hasDiabetes = val),
            )
          ],
        );
      case 3:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.pregnant_woman, color: Colors.purpleAccent, size: 28),
            const SizedBox(height: 8),
            const Text("Parameter 4: Is candidate currently pregnant?", style: TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 4),
            Switch(
              value: _isPregnant,
              activeTrackColor: Colors.purpleAccent.withAlpha((0.4 * 255).round()),
              activeThumbColor: Colors.purpleAccent,
              onChanged: (val) => setState(() => _isPregnant = val),
            )
          ],
        );
      default:
        return Container();
    }
  }

  String _fetchBrandedLanguageOutput() {
    if (selectedLanguage == "Hindi") {
      return "• यह अध्ययन टाइप 2 मधुमेह की दवा का परीक्षण करता है।\n• उम्र 18 से 60 के बीच और HbA1c स्तर 7 से 9 के बीच होना आवश्यक है।\n• चेतावनी: गर्भवती महिलाएं भाग नहीं ले सकतीं।";
    } else if (selectedLanguage == "Marathi") {
      return "• ही चाचणी प्रामुख्याने टाईप 2 मधुमेहाच्या नवीन उपचारासाठी आहे.\n• वय 18 ते 60 आणि HbA1c पातळी 7 ते 9 दरम्यान असणे आवश्यक आहे.\n• गरोदर महिला या चाचणीसाठी पात्र नाहीत.";
    }
    return "• Core Study Parameter: Evaluates clinical efficacy for managed Type 2 Diabetes parameters.\n• Inclusion Criteria: Adults aged 18 to 60 with quantified baseline HbA1c values isolated between 7.0 and 9.0.\n• Critical Disqualification Exclusion: Active gestation or maternal pregnancy framework states.";
  }
}