import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

void main() => runApp(const MyApp());

const Color kBackgroundRed = Color(0xFFEF5350);
const Color kButtonYellow = Color(0xFFFFEB3B);
const Color kButtonBlue  = Color(0xFF4FC3F7);
const Color kButtonGrey  = Color(0xFFE0E0E0);
const String kLogoAsset  = 'assets/logo.png';       // your eagle logo
const String kUploadHint = 'assets/upload.png';     // placeholder before pick

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => const MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Hawkeye Mango',
    home: SplashPage(),
  );
}

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundRed,
      body: SafeArea(
        // 1) Center everything
        child: Center(
          // 2) Make the Column hug its contents
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Big Logo
              const CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage(kLogoAsset),
              ),
              const SizedBox(height: 24),
              const Text(
                'Hawkeye Mango',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Text(
                'An offine solution for Farmers to detect Mango Leaf Disease',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kButtonYellow,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 36, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Tap to Continue'),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const DetectorPage())
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class DetectorPage extends StatefulWidget {
  const DetectorPage({super.key});
  @override
  State<DetectorPage> createState() => _DetectorPageState();
}

class _DetectorPageState extends State<DetectorPage> {
  File?   _image;
  String  _label = '';
  double  _conf  = 0.0;
  final _picker = ImagePicker();

  // 1) Map each class to its own prevention & treatment text
  final Map<String, Map<String, String>> _diseaseInfo = {
    'Anthracnose': {
      'prevention': 'Remove fallen debris, improve air circulation, avoid overhead irrigation.',
      'treatment': 'Apply a copper‑based fungicide at first sign of spots; prune infected twigs.',
    },
    'Bacterial_Canker': {
      'prevention': 'Sanitize pruning tools, avoid wounding bark, space trees for airflow.',
      'treatment': 'Spray copper‑hydroxide during bloom; remove and destroy cankered branches.',
    },
    'Cutting_Weevil': {
      'prevention': 'Maintain clean field edges, remove debris, use resistant rootstocks.',
      'treatment': 'Apply systemic insecticide to soil; release beneficial nematodes.',
    },
    'Die_Back': {
      'prevention': 'Avoid water stress, mulch to retain soil moisture, balanced fertilization.',
      'treatment': 'Prune dead branches back to healthy tissue; apply protective wound paint.',
    },
    'Gall_Midge': {
      'prevention': 'Rotate crops, avoid planting near infested fields.',
      'treatment': 'Spray neem oil weekly; introduce predatory insects like lacewings.',
    },
    'Healthy': {
      'prevention': 'Continue regular monitoring, maintain good irrigation and nutrition.',
      'treatment': 'No treatment needed.',
    },
    'Powdery_Mildew': {
      'prevention': 'Ensure full sun exposure, avoid excessive nitrogen fertilization.',
      'treatment': 'Use sulfur or potassium bicarbonate sprays every 7–10 days.',
    },
    'Sooty_Mould': {
      'prevention': 'Control aphids and scale (honeydew producers), prune crowded branches.',
      'treatment': 'Wash leaves with mild soapy water; apply horticultural oil.',
    },
    'not_in_class': {
      'prevention': 'N/A',
      'treatment': 'N/A',
    },
  };

  @override
  void initState() {
    super.initState();
    Tflite.loadModel(
      model: 'assets/tiny_net_fold5.tflite',
      labels: 'assets/label.txt',
      isAsset: true,
    );
  }

  Future<void> _classify(ImageSource src) async {
    final XFile? img = await _picker.pickImage(source: src);
    if (img == null) return;

    setState(() => _image = File(img.path));

    final res = await Tflite.runModelOnImage(
      path: img.path,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 1,
      threshold: 0.0,
    );

    if (res != null && res.isNotEmpty) {
      setState(() {
        _label = res[0]['label'];
        _conf  = res[0]['confidence'] * 100;
      });
    }
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // get the info map for the current label (or a default stub)
    final info = _diseaseInfo[_label] ??
        {'prevention':'N/A','treatment':'N/A'};

    return Scaffold(
      backgroundColor: kBackgroundRed,
      body: SafeArea(
        child: Column(
          children: [
            // — Header —
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:16, vertical:12),
              child: Row(
                children: [
                  Image.asset(kLogoAsset, width:48, height:48),
                  const Center(child: SizedBox(width:50)),
                  const Center(
                    child: Text(
                      'Hawkeye Mango',
                      textAlign: TextAlign.center,
                      style: TextStyle(color:Colors.white, fontSize:24, fontWeight:FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height:64),

            // — Circle Image —
            Center(
              child: CircleAvatar(
                radius:120,
                backgroundColor:Colors.white,
                backgroundImage: _image==null
                    ? const AssetImage(kLogoAsset) as ImageProvider
                    : FileImage(_image!),
              ),
            ),

            const SizedBox(height:16),

            // — Result Card + Prevention/Treatment —
            if (_label.isNotEmpty) ...[
              // result
              Container(
                margin: const EdgeInsets.symmetric(horizontal:40),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:Colors.white,
                  borderRadius:BorderRadius.circular(16),
                  boxShadow:const [BoxShadow(color:Colors.black26, blurRadius:6, offset:Offset(0,3))],
                ),
                child: Column(
                  children:[
                    Text('Detected: $_label',
                        style: const TextStyle(fontSize:24, fontWeight:FontWeight.bold)),
                    const SizedBox(height:6),
                    if (_label != 'not_in_class')
                      Text('Accuracy: ${_conf.toStringAsFixed(2)}%',
                          style: const TextStyle(fontSize:20)),
                  ],
                ),
              ),

              const SizedBox(height:16),

              // prevention & treatment
              Container(
                margin: const EdgeInsets.symmetric(horizontal:24),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:Colors.white,
                  borderRadius:BorderRadius.circular(16),
                  boxShadow:const [BoxShadow(color:Colors.black26, blurRadius:6, offset:Offset(0,3))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    const Text('Disease Prevention & Treatments:',
                        style: TextStyle(fontSize:16, fontWeight:FontWeight.bold)),

                    const SizedBox(height:8),
                    const Text('Prevention:', style: TextStyle(fontWeight:FontWeight.w600)),
                    Text(info['prevention']!),

                    const SizedBox(height:12),
                    const Text('Treatment:', style: TextStyle(fontWeight:FontWeight.w600)),
                    Text(info['treatment']!),
                  ],
                ),
              ),

              const SizedBox(height:72),
            ],

            // — Bottom Buttons —
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:[
                  _ActionButton(
                    color: kButtonBlue,
                    label: 'Take a Photo',
                    onTap: () => _classify(ImageSource.camera),
                  ),
                  _ActionButton(
                    color: kButtonGrey,
                    label: 'Pick from Gallery',
                    onTap: () => _classify(ImageSource.gallery),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _ActionButton extends StatelessWidget {
  final Color color;
  final String label;
  final VoidCallback onTap;
  const _ActionButton({
    required this.color,
    required this.label,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onTap,
      child: Text(label),
    );
  }
}
