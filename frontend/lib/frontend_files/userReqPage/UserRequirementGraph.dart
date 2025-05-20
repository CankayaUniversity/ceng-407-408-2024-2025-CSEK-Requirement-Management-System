import 'package:flutter/material.dart';
import 'package:frontend/backend/subsystems/subsystem1_requirements/subsystem1_requirement_model.dart';
import 'package:frontend/backend/subsystems/subsystem2_requirements/subsystem2_requirement_model.dart';
import 'package:frontend/backend/subsystems/subsystem3_requirements/subsystem3_requirement_model.dart';
import 'package:frontend/backend/system_requirements/system_requirement_model.dart';
import 'package:graphview/GraphView.dart';

class UserRequirementGraph extends StatelessWidget {
  final String kgTitle;
  final List<SystemReqModel> systemRequirements;
  final List<Subsystem1ReqModel> subsystem1;
  final List<Subsystem2ReqModel> subsystem2;
  final List<Subsystem3ReqModel> subsystem3;

  const UserRequirementGraph({
    super.key,
    required this.kgTitle,
    required this.systemRequirements,
    required this.subsystem1,
    required this.subsystem2,
    required this.subsystem3,
  });

  @override
  Widget build(BuildContext context) {
    final graph = Graph()..isTree = false;
    final config =
        BuchheimWalkerConfiguration()
          ..siblingSeparation = 30
          ..levelSeparation = 50
          ..subtreeSeparation = 30
          ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;

    final kgNode = Node.Id(kgTitle);
    graph.addNode(kgNode);

    for (var sg in systemRequirements) {
      final sgNode = Node.Id(sg.title);
      graph.addEdge(kgNode, sgNode);

      final sgId = sg.id;
      for (var sg in systemRequirements) {
        final sgNode = Node.Id(sg.title);
        graph.addEdge(kgNode, sgNode);

        final sgId = sg.id;

        for (var dg in subsystem1) {
          if (dg.systemRequirementId == sgId) {
            final dgNode = Node.Id(dg.title);
            graph.addEdge(sgNode, dgNode);
          }
        }
        for (var dg in subsystem2) {
          if (dg.systemRequirementId == sgId) {
            final dgNode = Node.Id(dg.title);
            graph.addEdge(sgNode, dgNode);
          }
        }
        for (var dg in subsystem3) {
          if (dg.systemRequirementId == sgId) {
            final dgNode = Node.Id(dg.title);
            graph.addEdge(sgNode, dgNode);
          }
        }
      }
    }

    return SizedBox(
      height: 400,
      child: InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(50),
        constrained: false,
        child: GraphView(
          graph: graph,
          algorithm: BuchheimWalkerAlgorithm(config, TreeEdgeRenderer(config)),
          builder: (Node node) {
            return nodeWidget(node.key!.value as String);
          },
        ),
      ),
    );
  }

  Widget nodeWidget(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF2E3440),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF81A1C1), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFD8DEE9),
          fontWeight: FontWeight.bold,
          fontSize: 14,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
