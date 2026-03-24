import 'package:flutter/material.dart';

class CameraCard extends StatelessWidget {
  final String id;
  final String name;
  final String location;
  final String status;
  final int fps;
  final int latency;
  final bool isReal;
  // THÊM: Callback khi click vào card
  final VoidCallback? onTap; 

  const CameraCard({
    super.key,
    required this.id,
    required this.name,
    required this.location,
    required this.status,
    this.fps = 0,
    this.latency = 0,
    this.isReal = false,
    this.onTap, // THÊM
  });

  Color _getStatusColor() {
    switch (status) {
      case 'critical': return Colors.red;
      case 'warning': return Colors.yellow;
      case 'disconnected': return Colors.grey;
      default: return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Bọc LayoutBuilder trong GestureDetector để bắt sự kiện click
    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isSmall = constraints.maxHeight < 120;

          return Container(
            // Giữ hiệu ứng hover/click nhẹ (tuỳ chọn)
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- PHẦN PREVIEW ---
                Expanded(
                  flex: 6,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(9)),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          _getStatusColor().withOpacity(0.2),
                          Colors.black.withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            Icons.videocam,
                            color: _getStatusColor(),
                            size: isSmall ? 20 : 28,
                          ),
                        ),
                        if (isReal && !isSmall)
                          Positioned(
                            top: 0, right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.red.shade600, Colors.red.shade900],
                                ),
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(9),
                                  bottomLeft: Radius.circular(6),
                                ),
                              ),
                              child: const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // --- PHẦN INFO ---
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: EdgeInsets.all(isSmall ? 4.0 : 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isSmall ? 10 : 12,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        
                        if (!isSmall)
                           Flexible(
                             child: Row(
                              children: [
                                Icon(Icons.location_on, size: 10, color: Colors.grey[400]),
                                const SizedBox(width: 2),
                                Expanded(
                                  child: Text(
                                    location,
                                    style: TextStyle(color: Colors.grey[400], fontSize: 10),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                             ),
                           ),

                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: _getStatusColor().withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(3),
                                  border: Border.all(color: _getStatusColor(), width: 0.5),
                                ),
                                child: Text(
                                  status.toUpperCase(),
                                  style: TextStyle(color: _getStatusColor(), fontSize: 7, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(Icons.speed, size: 9, color: Colors.blue.shade400),
                              const SizedBox(width: 2),
                              Text('$fps', style: const TextStyle(color: Colors.white70, fontSize: 9)),
                              const SizedBox(width: 6),
                              Icon(Icons.timer, size: 9, color: latency < 150 ? Colors.green : Colors.orange),
                              const SizedBox(width: 2),
                              Text('$latency ms', style: const TextStyle(color: Colors.white70, fontSize: 9)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}