import 'dart:convert';

/// Static in-memory data source that returns JSON strings mirroring the
/// JSONPlaceholder API contract. Used to exercise the same parsing path as the
/// future API-backed data source.
class MockPostDataSource {
  static const List<Map<String, Object>> _posts = [
    {
      'userId': 1,
      'id': 1,
      'title':
          'sunt aut facere repellat provident occaecati excepturi optio reprehenderit',
      'body':
          'quia et suscipit suscipit recusandae consequuntur expedita et cum reprehenderit molestiae ut ut quas totam nostrum rerum est autem sunt rem eveniet architecto',
    },
    {
      'userId': 1,
      'id': 2,
      'title': 'qui est esse',
      'body':
          'est rerum tempore vitae sequi sint nihil reprehenderit dolor beatae ea dolores neque fugiat blanditiis voluptate porro vel nihil molestiae ut reiciendis qui aperiam non debitis possimus qui neque nisi nulla',
    },
    {
      'userId': 2,
      'id': 3,
      'title': 'ea molestias quasi exercitationem repellat qui ipsa sit aut',
      'body':
          'et iusto sed quo iure voluptatem occaecati omnis eligendi aut ad voluptatem doloribus vel accusantium quis pariatur molestiae porro eius odio et labore et velit aut',
    },
    {
      'userId': 2,
      'id': 4,
      'title': 'eum et est occaecati',
      'body':
          'ullam et saepe reiciendis voluptatem adipisci sit amet autem assumenda provident rerum culpa quis hic commodi nesciunt rem tenetur doloremque ipsam iure quis sunt voluptatem rerum illo velit',
    },
    {
      'userId': 3,
      'id': 5,
      'title': 'nesciunt quas odio',
      'body':
          'repudiandae veniam quaerat sunt sed alias aut fugiat sit autem sed est voluptatem omnis possimus esse voluptatibus quis est aut tenetur dolor neque',
    },
    {
      'userId': 3,
      'id': 6,
      'title': 'dolorem eum magni eos aperiam quia',
      'body':
          'ut aspernatur corporis harum nihil quis provident sequi mollitia nobis aliquid molestiae perspiciatis et ea nemo ab reprehenderit accusantium quas voluptate dolores velit et doloremque molestiae',
    },
    {
      'userId': 4,
      'id': 7,
      'title': 'magnam facilis autem',
      'body':
          'dolore placeat quibusdam ea quo vitae magni quis enim qui quis quo nemo aut saepe quidem repellat excepturi ut quia sunt ut sequi eos ea sed quas',
    },
    {
      'userId': 4,
      'id': 8,
      'title': 'dolorem dolore est ipsam',
      'body':
          'dignissimos aperiam dolorem qui eum facilis quibusdam animi sint suscipit qui sint possimus cum quaerat magni maiores excepturi ipsam ut commodi dolor voluptatum modi aut vitae',
    },
    {
      'userId': 5,
      'id': 9,
      'title': 'nesciunt iure omnis dolorem tempora et accusantium',
      'body':
          'consectetur animi nesciunt iure dolore enim quia ad veniam autem ut quam aut nobis et est aut quod aut provident voluptas autem voluptas',
    },
    {
      'userId': 5,
      'id': 10,
      'title': 'optio molestias id quia eum',
      'body':
          'quo et expedita modi cum officia vel magni doloribus qui repudiandae vero nisi sit quos veniam quod sed accusamus veritatis error',
    },
  ];

  static const List<Map<String, Object>> _users = [
    {
      'id': 1,
      'name': 'Leanne Graham',
      'username': 'Bret',
      'email': 'Sincere@april.biz',
    },
    {
      'id': 2,
      'name': 'Ervin Howell',
      'username': 'Antonette',
      'email': 'Shanna@melissa.tv',
    },
    {
      'id': 3,
      'name': 'Clementine Bauch',
      'username': 'Samantha',
      'email': 'Nathan@yesenia.net',
    },
    {
      'id': 4,
      'name': 'Patricia Lebsack',
      'username': 'Karianne',
      'email': 'Julianne.OConner@kory.org',
    },
    {
      'id': 5,
      'name': 'Chelsey Dietrich',
      'username': 'Kamren',
      'email': 'Lucio_Hettinger@annie.ca',
    },
  ];

  static const List<Map<String, Object>> _comments = [
    {
      'postId': 1,
      'id': 1,
      'name': 'id labore ex et quam laborum',
      'email': 'Eliseo@gardner.biz',
      'body':
          'laudantium enim quasi est quidem magnam voluptate ipsam eos tempora quo necessitatibus dolor quam autem quasi reiciendis et nam sapiente accusantium',
    },
    {
      'postId': 1,
      'id': 2,
      'name': 'quo vero reiciendis velit similique earum',
      'email': 'Jayne_Kuhic@sydney.com',
      'body':
          'est natus enim nihil est dolore omnis voluptatem numquam et omnis occaecati quod ullam at voluptatem error expedita pariatur nihil sint nostrum voluptatem reiciendis et',
    },
    {
      'postId': 1,
      'id': 3,
      'name': 'odio adipisci rerum aut animi',
      'email': 'Nikita@garfield.biz',
      'body':
          'quia molestiae reprehenderit quasi aspernatur aut expedita occaecati aliquam eveniet laudantium omnis quibusdam delectus saepe quia accusamus maiores nam est cum et ducimus et vero voluptates excepturi deleniti ratione',
    },
    {
      'postId': 2,
      'id': 4,
      'name': 'alias odio sit',
      'email': 'Lew@alysha.tv',
      'body':
          'non et atque occaecati deserunt quas accusantium unde odit nobis qui voluptatem quia voluptas consequuntur itaque dolor et qui rerum deleniti ut occaecati',
    },
    {
      'postId': 2,
      'id': 5,
      'name': 'vero eaque aliquid doloribus et culpa',
      'email': 'Hayden@althea.biz',
      'body':
          'harum non quasi et ratione tempore iure ex voluptates in ratione harum architecto fugit inventore cupiditate voluptates magni quo et',
    },
    {
      'postId': 3,
      'id': 6,
      'name': 'et fugit eligendi deleniti quidem qui sint nihil autem',
      'email': 'Presley.Mueller@myrl.com',
      'body':
          'doloribus at sed quis culpa deserunt consectetur qui praesentium accusamus fugiat dicta voluptatem rerum ut voluptate autem voluptatem repellendus aspernatur dolorem in',
    },
    {
      'postId': 3,
      'id': 7,
      'name': 'repellat consequatur praesentium vel minus molestias voluptatum',
      'email': 'Dallas@ole.me',
      'body':
          'maiores sed dolores similique labore et inventore et quasi temporibus esse sunt id et eos voluptatem aliquam aliquid ratione corporis molestiae mollitia quia et magnam dolor',
    },
  ];

  Future<String> fetchPostsJson() async => jsonEncode(_posts);

  Future<String> fetchUserJson(int id) async {
    final user = _users.firstWhere(
      (u) => u['id'] == id,
      orElse: () => throw StateError('User with id $id not found'),
    );
    return jsonEncode(user);
  }

  Future<String> fetchCommentsJson(int postId) async {
    final comments = _comments.where((c) => c['postId'] == postId).toList();
    return jsonEncode(comments);
  }
}
