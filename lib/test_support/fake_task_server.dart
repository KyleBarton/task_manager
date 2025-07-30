
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:task_manager/result.dart';

import '../project.dart';

enum ServerError {
  failedToStart,
}

class FakeTaskServer {
  final Map<int, Project> _data = {};
  int _latestProjectId = -1;

  HttpServer? server;

  Future<Result<void, ServerError>> start() async {
    var app = Router();
    app.get("/projects", _getAllProjects);
    app.post("/projects", _createProject);
    app.get("/projects/<id>", _getProjectById);
    app.put("/projects/<id>", _updateProjectById);
    server = await io.serve(app, "localhost", 8888);
    return Ok(());
  }

  Future<Result<void, ServerError>> stop() async {
    await server?.close();
    return Ok(());
  }

  Response _getAllProjects(Request _) {
    return Response(200, body: jsonEncode(_data));
  }

  Future<Response> _createProject(Request req) async {
    var rawBody = await req.readAsString();

    Map<String, dynamic> body = jsonDecode(rawBody);

    var title = body["title"];
    var purpose = body["purpose"] ?? "";
    var outcomes = body["outcomes"] ?? "";
    var brainstorming = body["brainstorming"] ?? "";
    var organization = body["organization"] ?? "";
    var referenceData = body["referenceData"] ?? "";

    _latestProjectId++;
    var project = Project.create(
      title: title,
      purpose: purpose,
      outcomes: outcomes,
      brainstorming: brainstorming,
      organization: organization,
      referenceData: referenceData,
      tasks: List.empty(),
      id: _latestProjectId,
    );
    _data[project.id] = project;
    return Response(201, body: jsonEncode(project));
  }

  Response _getProjectById(Request request, String id) {
    final project = _data[int.parse(id)];
    return Response(200, body: jsonEncode(project));
  }

  Future<Response> _updateProjectById(Request request, String id) async {
    final project = _data[int.parse(id)];
    if (project == null) {
      return Response(404);
    }

    var rawBody = await request.readAsString();

    Map<String, dynamic> reqBody = jsonDecode(rawBody);

    var title = reqBody["title"] ?? "";
    var purpose = reqBody["purpose"] ?? "";
    var outcomes = reqBody["outcomes"] ?? "";
    var brainstorming = reqBody["brainstorming"] ?? "";
    var organization = reqBody["organization"] ?? "";
    var referenceData = reqBody["referenceData"] ?? "";

    if (title != "") {
      project.title = title;
    }
    if (purpose != "") {
      project.purpose = purpose;
    }
    if (outcomes != "") {
      project.outcomes = outcomes;
    }
    if (brainstorming != "") {
      project.brainstorming = brainstorming;
    }
    if (organization != "") {
      project.organization = organization;
    }
    if (referenceData != "") {
      project.referenceData = referenceData;
    }
    return Response(200);
  }
}
