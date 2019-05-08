// import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
// part 'search_args.g.dart';

// @JsonSerializable()
class SearchArgs {
  String operationName;
  String query;
  Variables variables;
  Extensions extensions;
  SearchArgs({this.operationName, this.query, this.variables, this.extensions});

  factory SearchArgs.fromJsonStr(String json) {
    return SearchArgs.fromJson(jsonDecode(json));
  }

  SearchArgs.fromJson(Map<String, dynamic> json) {
    operationName = json['operationName'];
    query = json['query'];
    variables = json['variables'] != null
        ? new Variables.fromJson(json['variables'])
        : null;
    extensions = json['extensions'] != null
        ? new Extensions.fromJson(json['extensions'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['operationName'] = this.operationName;
    data['query'] = this.query;
    if (this.variables != null) {
      data['variables'] = this.variables.toJson();
    }
    if (this.extensions != null) {
      data['extensions'] = this.extensions.toJson();
    }
    return data;
  }
}

// @JsonSerializable()
class Variables {
  List<String> tags;
  String category;
  int first;
  String after;
  String order;

  Variables({this.tags, this.category, this.first, this.after, this.order});

  Variables.fromJson(Map<String, dynamic> json) {
    tags = json['tags'] != null ? json['tags'].cast<String>() : null;
    category = json['category'];
    first = json['first'];
    after = json['after'];
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tags'] = this.tags;
    data['category'] = this.category;
    data['first'] = this.first;
    data['after'] = this.after;
    data['order'] = this.order;
    return data;
  }
}

// @JsonSerializable()
class Extensions {
  Query query;

  Extensions({this.query});

  Extensions.fromJson(Map<String, dynamic> json) {
    query = json['query'] != null ? new Query.fromJson(json['query']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.query != null) {
      data['query'] = this.query.toJson();
    }
    return data;
  }
}

// @JsonSerializable()
class Query {
  String id;

  Query({this.id});

  Query.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}
