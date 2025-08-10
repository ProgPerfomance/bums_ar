import 'dart:math' as math;

import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

late ARKitController arkitController;

class ArView extends StatelessWidget {
  const ArView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ARKitSceneView(
        onARKitViewCreated: onARKitViewCreated,
        enableTapRecognizer: true,
        planeDetection: ARPlaneDetection.horizontal,
      ),
    );
  }
}

void onARKitViewCreated(ARKitController controller) {
  arkitController = controller;

  arkitController.onAddNodeForAnchor = _handleNewAnchor;
  arkitController.onNodeTap = _handleNodeTap; // ⬅️ Слушаем тап по нодам

  // Сфера с уникальным name
  final node = ARKitNode(
    name: 'targetSphere',
    physicsBody: ARKitPhysicsBody(ARKitPhysicsBodyType.kinematic),
    geometry: ARKitSphere(radius: 0.1),
    position: Vector3(0, -2, -0.5),
  );

  arkitController.add(node);
}

void _handleNewAnchor(ARKitAnchor anchor) {
  if (anchor is ARKitPlaneAnchor) {
    final planeNode = ARKitNode(
      geometry: ARKitBox(
        width: 0.1,
        height: 0.1,
        length: 0.1,
        materials: [
          ARKitMaterial(
              diffuse: ARKitMaterialProperty.color(Color(0xFFFF0000)))
        ],
      ),
      position: Vector3(
        anchor.center.x,
        anchor.center.y + 0.05,
        anchor.center.z,
      ),
    );

    arkitController.add(planeNode);
    spawnSpheres(arkitController);
  }
}

void _handleNodeTap(List<String> nodeNames) {
  for (final name in nodeNames) {
    arkitController.remove(name);
    print("пиздец");
  }
}


void spawnSpheres(ARKitController controller, {int count = 7}) {
  const double fixedY = -3.0;
  const double radius = 1.0;

  for (int i = 0; i < count; i++) {
    final angle = (2 * math.pi / count) * i;
    final x = radius * math.cos(angle);
    final z = radius * math.sin(angle) - 1; // немного перед камерой

    controller.add(ARKitNode(
      name: 'sphere_$i',
      geometry: ARKitSphere(radius: 0.1),
      position: Vector3(x, fixedY, z),
      physicsBody: ARKitPhysicsBody(ARKitPhysicsBodyType.kinematic),
    ));
  }
}
