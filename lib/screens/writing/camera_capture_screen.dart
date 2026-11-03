import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../widgets/dashed_box.dart';

/// Kamera dengan kotak putus-putus "Tulisan kamu di sini".
/// Mengembalikan path foto lewat `Navigator.pop(context, path)`.
///
/// Kotak = 72% lebar pratinjau, di tengah. `HandwritingScorer` memotong foto
/// dengan proporsi yang sama, jadi ubah angka 0.72 di KEDUA tempat bersamaan.
class CameraCaptureScreen extends StatefulWidget {
  final String title;
  const CameraCaptureScreen({super.key, required this.title});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  CameraController? _controller;
  String? _error;
  bool _taking = false;

  @override
  void initState() {
    super.initState();
    _setup();
  }

  Future<void> _setup() async {
    try {
      final cams = await availableCameras();
      if (cams.isEmpty) throw StateError('no camera');
      final cam = cams.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cams.first,
      );
      final c = CameraController(cam, ResolutionPreset.high, enableAudio: false);
      await c.initialize();
      if (!mounted) {
        await c.dispose();
        return;
      }
      setState(() => _controller = c);
    } catch (_) {
      if (mounted) {
        setState(() => _error =
            'Kamera tidak bisa dibuka. Pastikan izin kamera sudah diberikan.');
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _shoot() async {
    final c = _controller;
    if (c == null || !c.value.isInitialized || _taking) return;
    setState(() => _taking = true);
    try {
      final file = await c.takePicture();
      if (mounted) Navigator.of(context).pop(file.path);
    } catch (_) {
      if (mounted) {
        setState(() => _taking = false);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal mengambil foto. Coba lagi.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: Center(child: _preview())),
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text('Cahaya cukup, tulisan di dalam kotak',
                  style: TextStyle(color: Colors.white70)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: GestureDetector(
                onTap: _shoot,
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _taking ? AppColors.disabled : Colors.white,
                    border: Border.all(color: AppColors.orange, width: 5),
                  ),
                  child: _taking
                      ? const Padding(
                          padding: EdgeInsets.all(22),
                          child: CircularProgressIndicator(strokeWidth: 3),
                        )
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _preview() {
    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Text(_error!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white)),
      );
    }
    final c = _controller;
    if (c == null || !c.value.isInitialized) {
      return const CircularProgressIndicator(color: Colors.white);
    }
    return AspectRatio(
      aspectRatio: 1 / c.value.aspectRatio, // potret
      child: Stack(
        children: [
          Positioned.fill(child: CameraPreview(c)),
          Positioned.fill(
            child: LayoutBuilder(
              builder: (_, box) {
                final side = box.maxWidth * 0.72;
                return Center(
                  child: SizedBox(
                    width: side,
                    height: side,
                    child: DashedBox(
                      color: Colors.white,
                      child: const Center(
                        child: Text(
                          'Tulisan kamu di sini',
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
