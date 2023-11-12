import 'package:dallumweek12/Models/AuthResponse.dart';
import 'package:dallumweek12/Models/LoginStructure.dart';
import 'package:dio/dio.dart';
import '../Models/User.dart';
import 'DataService.dart';

const String BaseUrl = "https://cmsc2204-mobile-api.onrender.com/Auth";

class UserClient {
  final _dio = Dio(BaseOptions(baseUrl: BaseUrl));
  DataService _dataService = DataService();

  Future<AuthResponse?> Login(LoginStructure user) async {
    try {
      var response = await _dio.post("/login",
          data: {'username': user.username, 'password': user.password});

      var data = response.data['data'];

      var authResponse = new AuthResponse(data['userId'], data['token']);

      if (authResponse.token != null) {
        await _dataService.AddItem("token", authResponse.token);
      }

      return authResponse;
    } catch (error) {
      return null;
    }
  }

  Future<String> GetApiVersion() async {
    var response = await _dio.get("/ApiVersion");
    return response.data;
  }

  Future<List<User>?> GetUsersAsync() async {
    try {
      var token = await _dataService.TryGetItem("token");
      if (await _dataService.TryGetItem("token") != null) {
        var response = await _dio.get("/GetUsers",
            options: Options(headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Authorization": "Bearer $token"
            }));
        List<User> users = new List.empty(growable: true);
        if (response != null) {
          for (var user in response.data) {
            users.add(User(user["_id"], user["Username"], user["Password"],
                user["Email"], user["AuthLevel"]));
          }
          return users;
        }
      } else {
        return null;
      }
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      var token = await _dataService.TryGetItem("token");
      if (token != null) {
        await _dio.post("/DeleteUserById",
            data: {
              'id': userId,
            },
            options: Options(headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Authorization": "Bearer $token"
            }));
      }
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<void> addUser(User user) async {
    try {
      var token = await _dataService.TryGetItem("token");
      if (token != null) {
        await _dio.post("/AddUser",
            data: {
              'username': user.Username,
              'password': user.Password,
              'email': user.Email,
              'authLevel': user.AuthLevel,
            },
            options: Options(headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Authorization": "Bearer $token"
            }));
      }
    } catch (error) {
      print(error);
      return null;
    }
  }
}
