import 'package:Gixa/Modules/Documents/model/view_documents_model.dart';
import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';

class StudentDocumentService {
  static Future<List<StudentDocumentModel>> fetchDocuments() async {
    final response = await ApiClient.get(
      ApiEndpoints.studentDocuments, // /api/student/documents/
    );

    return (response as List)
        .map((e) => StudentDocumentModel.fromJson(e))
        .toList();
  }
}
