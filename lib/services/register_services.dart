import 'package:Gixa/Modules/register/model/register_request.dart';
import 'package:Gixa/Modules/register/model/register_response.dart';
import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';
import 'package:Gixa/network/app_exception.dart';

class RegisterApiService {
  Future<RegisterStudentResponse> registerStudent(
    RegisterStudentRequest request,
  ) async {
    final response = await ApiClient.postForm(
      ApiEndpoints.registerStudent,
      request.toJson(),
    );

    if (response['token'] == null || response['user'] == null) {
      throw AppException(
        message: "Registration failed. Please try again.",
        debugMessage: "Invalid register API response format",
      );
    }

    return RegisterStudentResponse.fromJson(response);
  }
}
