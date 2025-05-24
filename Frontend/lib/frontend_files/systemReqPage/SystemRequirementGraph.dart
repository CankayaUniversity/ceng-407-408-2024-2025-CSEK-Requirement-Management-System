import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

class SystemRequirementGraph extends StatelessWidget {
  final String kgTitle;
  final String sgTitle;
  final List<String> subsystemTitles;
  final Function(String)? onNodeTap;

  const SystemRequirementGraph({
    super.key,
    required this.kgTitle,
    required this.sgTitle,
    required this.subsystemTitles,
    this.onNodeTap,
  });

  @override
  Widget build(BuildContext context) {
    final graph = Graph()..isTree = false;
    final builder =
        BuchheimWalkerConfiguration()
          ..siblingSeparation = 30
          ..levelSeparation = 50
          ..subtreeSeparation = 30
          ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;

    final kgNode = Node.Id(kgTitle);
    final sgNode = Node.Id(sgTitle);
    graph.addEdge(kgNode, sgNode);

    for (var sub in subsystemTitles) {
      final subNode = Node.Id(sub);
      graph.addEdge(sgNode, subNode);
    }

    return SizedBox(
      height: 300,
      child: InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(50),
        constrained: false,
        child: GraphView(
          graph: graph,
          algorithm: BuchheimWalkerAlgorithm(
            builder,
            TreeEdgeRenderer(builder),
          ),
          builder: (Node node) {
            final title = node.key!.value as String;
            return GestureDetector(
              onTap: () => onNodeTap?.call(title),
              child: nodeWidget(title),
            );
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
