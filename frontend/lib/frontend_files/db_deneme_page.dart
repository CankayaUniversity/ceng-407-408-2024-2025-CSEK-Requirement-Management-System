import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/backend/user_requirements/user_requirement_model.dart';
import 'package:frontend/backend/user_requirements/user_requirement_provider.dart';
import 'package:frontend/backend/system_requirements/system_requirement_model.dart';
import 'package:frontend/backend/system_requirements/system_requirement_provider.dart';
import 'package:frontend/backend/subsystems/subsystem1_requirements/subsystem1_requirement_model.dart';
import 'package:frontend/backend/subsystems/subsystem1_requirements/subsystem1_requirement_provider.dart';
import 'package:frontend/backend/subsystems/subsystem2_requirements/subsystem2_requirement_model.dart';
import 'package:frontend/backend/subsystems/subsystem2_requirements/subsystem2_requirement_provider.dart';
import 'package:frontend/backend/subsystems/subsystem3_requirements/subsystem3_requirement_model.dart';
import 'package:frontend/backend/subsystems/subsystem3_requirements/subsystem3_requirement_provider.dart';
import 'package:frontend/backend/attributes/user_attribute/user_attribute_api_service.dart';

import '../backend/attributes/sub1_attribute/sub1_attribute_model.dart';
import '../backend/attributes/sub1_attribute/sub1_attribute_provider.dart';
import '../backend/attributes/sub2_attribute/sub2_attribute_model.dart';
import '../backend/attributes/sub2_attribute/sub2_attribute_provider.dart';
import '../backend/attributes/sub3_attribute/sub3_attribute_model.dart';
import '../backend/attributes/sub3_attribute/sub3_attribute_provider.dart';
import '../backend/attributes/system_attribute/system_attribute_model.dart';
import '../backend/attributes/system_attribute/system_attribute_provider.dart';
import '../backend/attributes/user_attribute/user_attribute_model.dart';
import '../backend/attributes/user_attribute/user_attribute_provider.dart';
import '../backend/headers/header_userreq/header_userreq_model.dart';
import '../backend/headers/header_userreq/header_userreq_provider.dart';
import '../backend/headers/header_systemreq//header_systemreq_model.dart';
import '../backend/headers/header_systemreq//header_systemreq_provider.dart';
import '../backend/headers/header_sub1req//header_sub1req_model.dart';
import '../backend/headers/header_sub1req//header_sub1req_provider.dart';
import '../backend/headers/header_sub2req//header_sub2req_model.dart';
import '../backend/headers/header_sub2req//header_sub2req_provider.dart';
import '../backend/headers/header_sub3req//header_sub3req_model.dart';
import '../backend/headers/header_sub3req//header_sub3req_provider.dart';
import '../backend/changeLogs/user_requirements_change_log/changeLog_user_requirement_model.dart';
import '../backend/changeLogs/user_requirements_change_log/changeLog_user_requirement_provider.dart';
import '../backend/changeLogs/system_requirements_change_log/changeLog_system_requirement_model.dart';
import '../backend/changeLogs/system_requirements_change_log/changeLog_system_requirement_provider.dart';
import '../backend/changeLogs/subsystem1_requirements_change_log/changeLog_subsystem1_requirement_model.dart';
import '../backend/changeLogs/subsystem1_requirements_change_log/changeLog_subsystem1_requirement_provider.dart';
import '../backend/changeLogs/subsystem2_requirements_change_log/changeLog_subsystem2_requirement_model.dart';
import '../backend/changeLogs/subsystem2_requirements_change_log/changeLog_subsystem2_requirement_provider.dart';
import '../backend/changeLogs/subsystem3_requirements_change_log/changeLog_subsystem3_requirement_model.dart';
import '../backend/changeLogs/subsystem3_requirements_change_log/changeLog_subsystem3_requirement_provider.dart';

class DbDenemePage extends ConsumerWidget {
  const DbDenemePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userRequirementListProvider);
    final systemAsync = ref.watch(systemRequirementListProvider);
    final subsystem1Async = ref.watch(subsystem1RequirementListProvider);
    final subsystem2Async = ref.watch(subsystem2RequirementListProvider);
    final subsystem3Async = ref.watch(subsystem3RequirementListProvider);
    final userAttributeAsync = ref.watch(userAttributeListProvider);
    final sub1AttributeAsync = ref.watch(sub1AttributeListProvider);
    final sub2AttributeAsync = ref.watch(sub2AttributeListProvider);
    final sub3AttributeAsync = ref.watch(sub3AttributeListProvider);
    final systemAttributeAsync = ref.watch(systemAttributeListProvider);
    final userReqHeaderAsync = ref.watch(headerUserReqModelListProvider);
    final systemReqHeaderAsync = ref.watch(headerSystemReqModelListProvider);
    final sub1ReqHeaderAsync = ref.watch(headerSub1ReqModelListProvider);
    final sub2ReqHeaderAsync = ref.watch(headerSub2ReqModelListProvider);
    final sub3ReqHeaderAsync = ref.watch(headerSub3ReqModelListProvider);
    final changeLogUserRequirementsAsync = ref.watch(userRequirementChangeLogListProvider);
    final changeLogSystemRequirementsAsync = ref.watch(systemRequirementChangeLogListProvider);
    final changeLogSubsystem1RequirementsAsync = ref.watch(subsystem1RequirementChangeLogListProvider);
    final changeLogSubsystem2RequirementsAsync = ref.watch(subsystem2RequirementChangeLogListProvider);
    final changeLogSubsystem3RequirementsAsync = ref.watch(subsystem3RequirementChangeLogListProvider);



    return Scaffold(
      appBar: AppBar(
        title: const Text('Veritabanı Deneme Sayfası'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('User Requirements'),
            _buildUserRequirements(userAsync),
            _sectionTitle('System Requirements'),
            _buildSystemRequirements(systemAsync),
            _sectionTitle('Subsystem1 Requirements'),
            _buildSubsystem1Requirements(subsystem1Async),
            _sectionTitle('Subsystem2 Requirements'),
            _buildSubsystem2Requirements(subsystem2Async),
            _sectionTitle('Subsystem3 Requirements'),
            _buildSubsystem3Requirements(subsystem3Async),
            _sectionTitle('User Attributes'),
            _buildUserAttributes(userAttributeAsync),
            _sectionTitle('Sub1 Attributes'),
            _buildSub1Attributes(sub1AttributeAsync),
            _sectionTitle('Sub2 Attributes'),
            _buildSub2Attributes(sub2AttributeAsync),
            _sectionTitle('Sub3 Attributes'),
            _buildSub3Attributes(sub3AttributeAsync),
            _sectionTitle('System Attributes'),
            _buildSystemAttributes(systemAttributeAsync),
            _sectionTitle('User Requirements Header'),
            _buildUserReqHeaders(userReqHeaderAsync),
            _sectionTitle('System Requirements Header'),
            _buildSystemReqHeaders(systemReqHeaderAsync),
            _sectionTitle('Subsystem1 Requirements Header'),
            _buildSubsystem1ReqHeaders(sub1ReqHeaderAsync),
            _sectionTitle('Subsystem2 Requirements Header'),
            _buildSubsystem2ReqHeaders(sub2ReqHeaderAsync),
            _sectionTitle('Subsystem3 Requirements Header'),
            _buildSubsystem3ReqHeaders(sub3ReqHeaderAsync),
            _sectionTitle('Change Log User Requirements'),
            _buildUserRequirementChangeLogs(changeLogUserRequirementsAsync),
            _sectionTitle('Change Log System Requirements'),
            _buildSystemRequirementChangeLogs(changeLogSystemRequirementsAsync),
            _sectionTitle('Change Log Subsystem 1 Requirements'),
            _buildSubsystem1RequirementChangeLogs(changeLogSubsystem1RequirementsAsync),
            _sectionTitle('Change Log Subsystem 2 Requirements'),
            _buildSubsystem2RequirementChangeLogs(changeLogSubsystem2RequirementsAsync),
            _sectionTitle('Change Log Subsystem 3 Requirements'),
            _buildSubsystem3RequirementChangeLogs(changeLogSubsystem3RequirementsAsync),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildUserRequirements(AsyncValue<List<UserReqModel>> data) {
    return data.when(
      data: (list) => Column(
        children: list.map((item) => ListTile(
          title: Text(item.title),
          subtitle: Text(item.description),
        )).toList(),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Hata: $e')),
    );
  }

  Widget _buildSystemRequirements(AsyncValue<List<SystemReqModel>> data) {
    return data.when(
      data: (list) => Column(
        children: list.map((item) => ListTile(
          title: Text(item.title),
          subtitle: Text('${item.description} (User ID: ${item.user_req_id})'),
        )).toList(),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Hata: $e')),
    );
  }

  Widget _buildSubsystem1Requirements(AsyncValue<List<Subsystem1ReqModel>> data) {
    return data.when(
      data: (list) => Column(
        children: list.map((item) => ListTile(
          title: Text(item.title),
          subtitle: Text('${item.description} (System ID: ${item.systemRequirementId})'),
        )).toList(),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Hata: $e')),
    );
  }

  Widget _buildSubsystem2Requirements(AsyncValue<List<Subsystem2ReqModel>> data) {
    return data.when(
      data: (list) => Column(
        children: list.map((item) => ListTile(
          title: Text(item.title),
          subtitle: Text('${item.description} (System ID: ${item.systemRequirementId})'),
        )).toList(),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Hata: $e')),
    );
  }

  Widget _buildSubsystem3Requirements(AsyncValue<List<Subsystem3ReqModel>> data) {
    return data.when(
      data: (list) => Column(
        children: list.map((item) => ListTile(
          title: Text(item.title),
          subtitle: Text('${item.description} (System ID: ${item.systemRequirementId})'),
        )).toList(),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Hata: $e')),
    );
  }

  Widget _buildUserAttributes(AsyncValue<List<UserAttributeModel>> data) {
    return data.when(
      data: (list) => Column(
        children: list.map((item) => ListTile(
          title: Text(item.header),
          subtitle: Text('${item.description} (User Req ID: ${item.userRequirementId})'),
        )).toList(),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Hata: $e')),
    );
  }
  Widget _buildSystemAttributes(AsyncValue<List<SystemAttributeModel>> data) {
    return data.when(
      data: (list) => Column(
        children: list.map((item) => ListTile(
          title: Text(item.header),
          subtitle: Text('${item.description} (System ID: ${item.systemRequirementId})'),
        )).toList(),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Hata: $e')),
    );
  }
  Widget _buildSub1Attributes(AsyncValue<List<Sub1AttributeModel>> data) {
    return data.when(
      data: (list) => Column(
        children: list.map((item) => ListTile(
          title: Text(item.title),
          subtitle: Text('${item.description} (Subsystem1 ID: ${item.subsystem1Id})'),
        )).toList(),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Hata: $e')),
    );
  }
  Widget _buildSub2Attributes(AsyncValue<List<Sub2AttributeModel>> data) {
    return data.when(
      data: (list) => Column(
        children: list.map((item) => ListTile(
          title: Text(item.title),
          subtitle: Text('${item.description} (Subsystem2 ID: ${item.subsystem2Id})'),
        )).toList(),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Hata: $e')),
    );
  }
  Widget _buildSub3Attributes(AsyncValue<List<Sub3AttributeModel>> data) {
    return data.when(
      data: (list) =>
          Column(
            children: list.map((item) =>
                ListTile(
                  title: Text(item.title),
                  subtitle: Text('${item.description} (Subsystem3 ID: ${item
                      .subsystem3Id})'),
                )).toList(),
          ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Hata: $e')),
    );
  }
  Widget _buildUserReqHeaders(AsyncValue<List<Header_UserReq_Model>> data) {
    return data.when(
      data: (list) => Column(
        children: list.map((item) => ListTile(
          title: Text(item.header),
        )).toList(),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Hata: $e')),
    );
  }
  Widget _buildSystemReqHeaders(AsyncValue<List<Header_SystemReq_Model>> data) {
    return data.when(
      data: (list) => Column(
        children: list.map((item) => ListTile(
          title: Text(item.header),
        )).toList(),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Hata: $e')),
    );
  }
  Widget _buildSubsystem1ReqHeaders(AsyncValue<List<Header_Sub1Req_Model>> data) {
    return data.when(
      data: (list) => Column(
        children: list.map((item) => ListTile(
          title: Text(item.header),
        )).toList(),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Hata: $e')),
    );
  }
  Widget _buildSubsystem2ReqHeaders(AsyncValue<List<Header_Sub2Req_Model>> data) {
    return data.when(
      data: (list) => Column(
        children: list.map((item) => ListTile(
          title: Text(item.header),
        )).toList(),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Hata: $e')),
    );
  }
  Widget _buildSubsystem3ReqHeaders(AsyncValue<List<Header_Sub3Req_Model>> data) {
    return data.when(
      data: (list) => Column(
        children: list.map((item) => ListTile(
          title: Text(item.header),
        )).toList(),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Hata: $e')),
    );
  }

  Widget _buildUserRequirementChangeLogs(AsyncValue<List<UserRequirementChangeLog>> data) {
    return data.when(
      data: (logs) => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: logs.length,
        itemBuilder: (context, index) {
          final log = logs[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.history),
              title: Text(log.changeType ?? 'Değişiklik'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID: ${log.id ?? "-"}'),
                  Text('Yapan: ${log.modifiedBy ?? "-"}'),
                  Text('Old Title: ${log.oldTitle ?? "-"}'),
                  Text('Old Description: ${log.oldDescription ?? "-"}'),
                  Text('Requirement ID: ${log.requirementId ?? "-"}'),
                  Text('Header: ${log.header != null ? log.header!.join(", ") : "-"}'),
                  Text('Old Attribute Description: ${log.oldAttributeDescription != null ? log.oldAttributeDescription!.join(", ") : "-"}'),
                  Text('Change Type: ${log.changeType ?? "-"}'),
                  Text('Tarih: ${log.modifiedAt?.toString() ?? "-"}'),
                ],
              ),
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Hata: $e')),
    );
  }

  Widget _buildSystemRequirementChangeLogs(AsyncValue<List<SystemRequirementChangeLog>> data) {
    return data.when(
      data: (logs) => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: logs.length,
        itemBuilder: (context, index) {
          final log = logs[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.history),
              title: Text(log.changeType ?? 'Değişiklik'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID: ${log.id ?? "-"}'),
                  Text('Yapan: ${log.modifiedBy ?? "-"}'),
                  Text('Old Title: ${log.oldTitle ?? "-"}'),
                  Text('Old Description: ${log.oldDescription ?? "-"}'),
                  Text('Requirement ID: ${log.requirementId ?? "-"}'),
                  Text('Header: ${log.header != null ? log.header!.join(", ") : "-"}'),
                  Text('Old Attribute Description: ${log.oldAttributeDescription != null ? log.oldAttributeDescription!.join(", ") : "-"}'),
                  Text('Change Type: ${log.changeType ?? "-"}'),
                  Text('Tarih: ${log.modifiedAt?.toString() ?? "-"}'),
                ],
              ),
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Hata: $e')),
    );
  }

  Widget _buildSubsystem1RequirementChangeLogs(AsyncValue<List<Subsystem1RequirementChangeLog>> data) {
    return data.when(
      data: (logs) => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: logs.length,
        itemBuilder: (context, index) {
          final log = logs[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.history),
              title: Text(log.changeType ?? 'Değişiklik'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID: ${log.id ?? "-"}'),
                  Text('Yapan: ${log.modifiedBy ?? "-"}'),
                  Text('Old Title: ${log.oldTitle ?? "-"}'),
                  Text('Old Description: ${log.oldDescription ?? "-"}'),
                  Text('Requirement ID: ${log.requirementId ?? "-"}'),
                  Text('Header: ${log.header != null ? log.header!.join(", ") : "-"}'),
                  Text('Old Attribute Description: ${log.oldAttributeDescription != null ? log.oldAttributeDescription!.join(", ") : "-"}'),
                  Text('Change Type: ${log.changeType ?? "-"}'),
                  Text('Tarih: ${log.modifiedAt?.toString() ?? "-"}'),
                ],
              ),
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Hata: $e')),
    );
  }

  Widget _buildSubsystem2RequirementChangeLogs(AsyncValue<List<Subsystem2RequirementChangeLog>> data) {
    return data.when(
      data: (logs) => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: logs.length,
        itemBuilder: (context, index) {
          final log = logs[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.history),
              title: Text(log.changeType ?? 'Değişiklik'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID: ${log.id ?? "-"}'),
                  Text('Yapan: ${log.modifiedBy ?? "-"}'),
                  Text('Old Title: ${log.oldTitle ?? "-"}'),
                  Text('Old Description: ${log.oldDescription ?? "-"}'),
                  Text('Requirement ID: ${log.requirementId ?? "-"}'),
                  Text('Header: ${log.header != null ? log.header!.join(", ") : "-"}'),
                  Text('Old Attribute Description: ${log.oldAttributeDescription != null ? log.oldAttributeDescription!.join(", ") : "-"}'),
                  Text('Change Type: ${log.changeType ?? "-"}'),
                  Text('Tarih: ${log.modifiedAt?.toString() ?? "-"}'),
                ],
              ),
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Hata: $e')),
    );
  }

  Widget _buildSubsystem3RequirementChangeLogs(AsyncValue<List<Subsystem3RequirementChangeLog>> data) {
    return data.when(
      data: (logs) => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: logs.length,
        itemBuilder: (context, index) {
          final log = logs[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.history),
              title: Text(log.changeType ?? 'Değişiklik'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID: ${log.id ?? "-"}'),
                  Text('Yapan: ${log.modifiedBy ?? "-"}'),
                  Text('Old Title: ${log.oldTitle ?? "-"}'),
                  Text('Old Description: ${log.oldDescription ?? "-"}'),
                  Text('Requirement ID: ${log.requirementId ?? "-"}'),
                  Text('Header: ${log.header != null ? log.header!.join(", ") : "-"}'),
                  Text('Old Attribute Description: ${log.oldAttributeDescription != null ? log.oldAttributeDescription!.join(", ") : "-"}'),
                  Text('Change Type: ${log.changeType ?? "-"}'),
                  Text('Tarih: ${log.modifiedAt?.toString() ?? "-"}'),
                ],
              ),
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Hata: $e')),
    );
  }


}