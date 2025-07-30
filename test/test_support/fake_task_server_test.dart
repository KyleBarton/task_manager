
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:task_manager/result.dart';
import 'package:task_manager/test_support/fake_task_server.dart';

void main() {
  FakeTaskServer server = FakeTaskServer();
  setUp(() async {
    (await server.start()).expect();
  });
  tearDown(() async {
    await server.stop();
  });
  test("Can get all projects", () async {

    final uri = Uri.parse("http://localhost:8888/projects");

    final response = await http.get(uri);

    assert (response.statusCode == 200);
  });
  test("Can create a project with a title", () async {
    final uri = Uri.parse("http://localhost:8888/projects");
    final body = { "title": "Project" };
    final response = await http.post(uri, body: jsonEncode(body));

    assert (response.statusCode == 201);
  });
  test("Can get a project by id", () async {
    final uri = Uri.parse("http://localhost:8888/projects");
    final body = {
      "title": "Project",
      "purpose": "Project Purpose",
      "outcomes": "Project Outcomes",
      'brainstorming': "Project Brainstorming",
      'organization': "Project Organization",
      'referenceData': "Project Reference Data",
      'tasks': List.empty(),
    };
    final response = await http.post(uri, body: jsonEncode(body));
    
    final Map<String, dynamic> responseBody = jsonDecode(response.body);
    assert (responseBody.containsKey('id'));

    final getResponse = await http.get(Uri.parse('http://localhost:8888/projects/${responseBody["id"]}'));

    assert (getResponse.statusCode == 200);

    final Map<String, dynamic> getResponseBody = jsonDecode(getResponse.body);

    assert (getResponseBody.containsKey("title"));

    assert (getResponseBody["title"] == "Project");
    assert (getResponseBody["purpose"] == "Project Purpose");
    assert (getResponseBody["outcomes"] == "Project Outcomes");
    assert (getResponseBody['brainstorming'] == "Project Brainstorming");
    assert (getResponseBody['organization'] == "Project Organization");
    assert (getResponseBody['referenceData'] == "Project Reference Data");
  });
  test("Can create multiple projects", () async {
    final uri = Uri.parse("http://localhost:8888/projects");
    final firstProject = {
      "title": "Project1",
    };
    final secondProject = {
      "title": "Project2",
    };
    final firstResponse = await http.post(uri, body: jsonEncode(firstProject));
    final firstResponseBody = jsonDecode(firstResponse.body);
    final secondResponse = await http.post(uri, body: jsonEncode(secondProject));
    final secondResponseBody = jsonDecode(secondResponse.body);

    final firstGetResponse = await http.get(Uri.parse('http://localhost:8888/projects/${firstResponseBody["id"]}'));
    final firstGetRespBody = jsonDecode(firstGetResponse.body);
    final secondGetResponse = await http.get(Uri.parse('http://localhost:8888/projects/${secondResponseBody["id"]}'));
    final secondGetRespBody = jsonDecode(secondGetResponse.body);

    assert (firstGetResponse.statusCode == 200 && secondGetResponse.statusCode == 200);
    assert (firstGetRespBody["title"] == "Project1");
    assert (secondGetRespBody["title"] == "Project2");
  });
  test("Can update a project", () async {
    final uri = Uri.parse("http://localhost:8888/projects");
    final body = {
      "title": "Project",
      "purpose": "Project Purpose",
      "outcomes": "Project Outcomes",
      'brainstorming': "Project Brainstorming",
      'organization': "Project Organization",
      'referenceData': "Project Reference Data",
      'tasks': List.empty(),
    };
    final response = await http.post(uri, body: jsonEncode(body));

    final Map<String, dynamic> responseBody = jsonDecode(response.body);
    final int id = responseBody['id'];

    final updateUri = Uri.parse('http://localhost:8888/projects/$id');
    final updateBody = {
      "title": "Updated title",
      "purpose": "Updated purpose",
      "outcomes": "Updated outcomes",
      "brainstorming": "Updated brainstorming",
      'organization': "Updated organization",
      'referenceData': "Updated referenceData",
    };

    final updateResponse = await http.put(updateUri, body: jsonEncode(updateBody));

    assert (updateResponse.statusCode == 200);

    final updatedGetResponse = await http.get(updateUri);
    final updatedBody = jsonDecode(updatedGetResponse.body);

    assert (updatedBody["title"] == "Updated title");
    assert (updatedBody["purpose"] == "Updated purpose");
    assert (updatedBody["outcomes"] == "Updated outcomes");
    assert (updatedBody["brainstorming"] == "Updated brainstorming");
    assert (updatedBody["organization"] == "Updated organization");
    assert (updatedBody["referenceData"] == "Updated referenceData");
  });
}