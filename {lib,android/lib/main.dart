import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const ESDizyneApp());
}

class ESDizyneApp extends StatelessWidget {
  const ESDizyneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ES Dizyne',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F13),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6C63FF),
          secondary: Color(0xFFFF6584),
          surface: Color(0xFF1A1A24),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F13),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'ES',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ES Dizyne',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Professional Design Suite',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Empty state
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.dashboard_customize,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No projects yet',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Create your first design',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditorScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        'New Project',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  String _activeTool = 'brush';
  Color _activeColor = Colors.black;
  final List<DrawnLine> _lines = [];
  DrawnLine? _currentLine;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F13),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A24),
        title: const Text(
          'ES Dizyne',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo, color: Colors.white),
            onPressed: () {
              setState(() {
                if (_lines.isNotEmpty) _lines.removeLast();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Row(
        children: [
          // Tools panel
          Container(
            width: 52,
            color: const Color(0xFF1A1A24),
            child: Column(
              children: [
                _toolButton(Icons.brush, 'brush'),
                _toolButton(Icons.edit, 'pencil'),
                _toolButton(Icons.auto_fix_off, 'eraser'),
                _toolButton(Icons.text_fields, 'text'),
                _toolButton(Icons.crop_square, 'rect'),
                _toolButton(Icons.circle_outlined, 'ellipse'),
                _toolButton(Icons.open_with, 'move'),
                const Spacer(),
                GestureDetector(
                  onTap: _pickColor,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _activeColor,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),

          // Canvas
          Expanded(
            child: GestureDetector(
              onPanStart: (details) {
                setState(() {
                  _currentLine = DrawnLine(
                    points: [details.localPosition],
                    color: _activeTool == 'eraser'
                        ? Colors.white
                        : _activeColor,
                    strokeWidth: _activeTool == 'eraser' ? 20 : 4,
                  );
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  _currentLine?.points.add(details.localPosition);
                });
              },
              onPanEnd: (_) {
                setState(() {
                  if (_currentLine != null) {
                    _lines.add(_currentLine!);
                    _currentLine = null;
                  }
                });
              },
              child: Container(
                color: Colors.white,
                child: CustomPaint(
                  painter: CanvasPainter(
                    lines: _lines,
                    currentLine: _currentLine,
                  ),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toolButton(IconData icon, String tool) {
    final isActive = _activeTool == tool;
    return GestureDetector(
      onTap: () => setState(() => _activeTool = tool),
      child: Container(
        width: 52,
        height: 48,
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF6C63FF).withOpacity(0.3)
              : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: isActive ? const Color(0xFF6C63FF) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isActive ? const Color(0xFF6C63FF) : Colors.grey,
        ),
      ),
    );
  }

  void _pickColor() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A24),
        title: const Text('Pick Color',
            style: TextStyle(color: Colors.white)),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Colors.black, Colors.white, Colors.red, Colors.green,
            Colors.blue, Colors.yellow, Colors.orange, Colors.purple,
            Colors.pink, Colors.teal, Colors.brown, Colors.grey,
          ].map((c) => GestureDetector(
            onTap: () {
              setState(() => _activeColor = c);
              Navigator.pop(context);
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: c,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
            ),
          )).toList(),
        ),
      ),
    );
  }
}

class DrawnLine {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;

  DrawnLine({
    required this.points,
    required this.color,
    required this.strokeWidth,
  });
}

class CanvasPainter extends CustomPainter {
  final List<DrawnLine> lines;
  final DrawnLine? currentLine;

  CanvasPainter({required this.lines, this.currentLine});

  @override
  void paint(Canvas canvas, Size size) {
    for (final line in [...lines, if (currentLine != null) currentLine!]) {
      final paint = Paint()
        ..color = line.color
        ..strokeWidth = line.strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      if (line.points.length < 2) continue;

      final path = Path()
        ..moveTo(line.points[0].dx, line.points[0].dy);

      for (int i = 1; i < line.points.length - 1; i++) {
        final mid = Offset(
          (line.points[i].dx + line.points[i + 1].dx) / 2,
          (line.points[i].dy + line.points[i + 1].dy) / 2,
        );
        path.quadraticBezierTo(
          line.points[i].dx, line.points[i].dy, mid.dx, mid.dy,
        );
      }

      path.lineTo(line.points.last.dx, line.points.last.dy);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CanvasPainter old) => true;
}
