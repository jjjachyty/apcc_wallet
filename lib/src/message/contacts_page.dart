import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/message/add_friends.dart';
import 'package:apcc_wallet/src/message/friend_profile.dart';
import 'package:apcc_wallet/src/message/new_friends.dart';
import 'package:apcc_wallet/src/model/im_friend.dart';
import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';

import 'constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

class _ContactItem extends StatelessWidget {
  _ContactItem({
    @required this.avatar,
    @required this.title,
    this.groupTitle,
    this.onPressed,
  });

  final String avatar;
  final String title;
  final String groupTitle;
  final VoidCallback onPressed;

  static const double MARGIN_VERTICAL = 10.0;
  static const double GROUP_TITLE_HEIGHT = 24.0;

  bool get _isAvatarFromNet {
    return this.avatar.startsWith('http') || this.avatar.startsWith("https");
  }

  static double _height(bool hasGroupTitle) {
    final _buttonHeight = MARGIN_VERTICAL * 2 +
        Constants.ContactAvatarSize +
        Constants.DividerWidth;
    if (hasGroupTitle) {
      return _buttonHeight + GROUP_TITLE_HEIGHT;
    } else {
      return _buttonHeight;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _avatarIcon;
    if (_isAvatarFromNet) {
      _avatarIcon = CachedNetworkImage(
        imageUrl: this.avatar,
        placeholder: (context, string) {
          return Image.asset("assets/images/loading.gif",width: 40,height: 40,);
        },
        width: Constants.ContactAvatarSize,
        height: Constants.ContactAvatarSize,
      );
    } else {
      _avatarIcon = Image.asset(
        this.avatar,
        width: Constants.ContactAvatarSize,
        height: Constants.ContactAvatarSize,
      );
    }

    Widget _button = GestureDetector(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.symmetric(vertical: MARGIN_VERTICAL),
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(
              width: Constants.DividerWidth,
              color: Color(AppColors.DividerColor)),
        )),
        child: Row(
          children: <Widget>[
            _avatarIcon,
            SizedBox(width: 10.0),
            Text(title),
          ],
        ),
      ),
      onTap: this.onPressed,
    );

    //分组标签
    Widget _itemBody;
    if (this.groupTitle != null) {
      _itemBody = Column(
        children: <Widget>[
          Container(
            height: GROUP_TITLE_HEIGHT,
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            color: const Color(AppColors.ContactGroupTitleBgColor),
            alignment: Alignment.centerLeft,
            child: Text.rich(TextSpan(text: this.groupTitle)),
          ),
          _button,
        ],
      );
    } else {
      _itemBody = _button;
    }

    return _itemBody;
  }
}

const INDEX_BAR_WORDS = [
  "↑",
  "★",
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
  "K",
  "L",
  "M",
  "N",
  "O",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "U",
  "V",
  "W",
  "X",
  "Y",
  "Z"
];

class ContactsPage extends StatefulWidget {
  Color _indexBarBgColor = Colors.transparent;
  String _currentLetter = '';
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  ScrollController _scrollController;
  final List<Friend> _contacts = [];
  List<_ContactItem> _functionButtons;
  final Map _letterPosMap = {INDEX_BAR_WORDS[0]: 0.0};

  buildfunctionButtons(BuildContext context) {
    _functionButtons = [
      _ContactItem(
          avatar: 'assets/images/msg_contact_new_friend.png',
          title: '新的好友',
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return NewFriends();
            }));
          }),
      // _ContactItem(
      //   avatar: 'assets/images/ic_group_chat.png',
      //   title: '群聊',
      //   onPressed: (){
      //     print("点击了群聊");
      //   }
      // ),
      // _ContactItem(
      //   avatar: 'assets/images/ic_tag.png',
      //   title: '标签',
      //   onPressed: (){
      //     print("点击了标签");
      //   }
      // ),
      // _ContactItem(
      //   avatar: 'assets/images/ic_public_account.png',
      //   title: '公众号',
      //   onPressed: (){
      //     print("添加公众号");
      //   }
      // ),
    ];

    //计算用于 IndexBar 进行定位的关键通讯录列表项的位置
    var _totalPos = _functionButtons.length * _ContactItem._height(false);
    for (var i = 0; i < _contacts.length; i++) {
      bool _hasGroupTitle = true;
      if (i > 0 &&
          _contacts[i].nameIndex.compareTo(_contacts[i - 1].nameIndex) == 0) {
        _hasGroupTitle = false;
      }

      if (_hasGroupTitle) {
        _letterPosMap[_contacts[i].nameIndex] = _totalPos;
      }
      _totalPos += _ContactItem._height(_hasGroupTitle);
    }
  }

  String getIndex(String name) {
    var pinyin = PinyinHelper.getPinyinE(name,
        separator: " ", defPinyin: '★', format: PinyinFormat.WITHOUT_TONE);
    return pinyin.substring(0, 1).toUpperCase();
  }

  @override
  void initState() {
    // TODO: implement initState
    _scrollController = new ScrollController();

    myFriends().then((data) {
      if (data.state) {
        setState(() {
          (data.data as List).forEach((frends) {
            Friend friend = Friend.fromJson(frends);
            friend.nameIndex = getIndex(friend.friendNickName);
            _contacts.add(friend);
          });
          _contacts.sort(
              (Friend a, Friend b) => a.nameIndex.compareTo(b.nameIndex));
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  String getLetter(BuildContext context, double tileHeight, Offset globalPos) {
    RenderBox _box = context.findRenderObject();
    var local = _box.globalToLocal(globalPos);
    int index = (local.dy ~/ tileHeight).clamp(0, INDEX_BAR_WORDS.length - 1);
    return INDEX_BAR_WORDS[index];
  }

  void _jumpToIndex(String letter) {
    if (_letterPosMap.isNotEmpty) {
      final _pos = _letterPosMap[letter];
      if (_pos != null) {
        _scrollController.animateTo(_letterPosMap[letter],
            curve: Curves.easeInOut, duration: Duration(microseconds: 200));
      }
    }
  }

  Widget _buildIndexBar(BuildContext context, BoxConstraints constraints) {
    final List<Widget> _letters = INDEX_BAR_WORDS.map((String word) {
      return Expanded(child: Text(word));
    }).toList();

    final _totalHeight = constraints.biggest.height;
    final _tileHeight = _totalHeight / _letters.length;
    print(_totalHeight);
    return GestureDetector(
      onVerticalDragDown: (DragDownDetails details) {
        setState(() {
          widget._indexBarBgColor = Colors.black26;
          widget._currentLetter =
              getLetter(context, _tileHeight, details.globalPosition);
          _jumpToIndex(widget._currentLetter);
        });
      },
      onVerticalDragEnd: (DragEndDetails details) {
        setState(() {
          widget._indexBarBgColor = Colors.transparent;
          widget._currentLetter = null;
        });
      },
      onVerticalDragCancel: () {
        setState(() {
          widget._indexBarBgColor = Colors.transparent;
          widget._currentLetter = null;
        });
      },
      onVerticalDragUpdate: (DragUpdateDetails details) {
        setState(() {
          var _letter = getLetter(context, _tileHeight, details.globalPosition);
          widget._currentLetter =
              getLetter(context, _tileHeight, details.globalPosition);
          _jumpToIndex(widget._currentLetter);
        });
      },
      child: Column(
        children: _letters,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    buildfunctionButtons(context);

    final List<Widget> _body = [
      ListView.builder(
        controller: _scrollController,
        itemBuilder: (BuildContext context, int index) {
          if (index < _functionButtons.length) {
            return _functionButtons[index];
          }
          int _contactIndex = index - _functionButtons.length;
          bool _isGroupTitle = true;
          Friend _contact = _contacts[_contactIndex];

          if (_contactIndex >= 1 &&
              _contact.nameIndex == _contacts[_contactIndex - 1].nameIndex) {
            _isGroupTitle = false;
          }
          return _ContactItem(
            avatar: imageHost + _contact.friendAvatar + ".webp",
            title: _contact.friendNickName,
            groupTitle: _isGroupTitle ? _contact.nameIndex : null,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return FriendPofilePage(_contact);
              }));
            },
          );
        },
        itemCount: _contacts.length + _functionButtons.length,
      ),
      Positioned(
        width: Constants.IndexBarWidth,
        right: 0.0,
        top: 0.0,
        bottom: 0.0,
        child: Container(
          color: widget._indexBarBgColor,
          child: LayoutBuilder(
            builder: _buildIndexBar,
          ),
        ),
      )
    ];

    if (widget._currentLetter != null && widget._currentLetter.isNotEmpty) {
      _body.add(Center(
        child: Container(
          width: Constants.IndexLetterBoxSize,
          height: Constants.IndexLetterBoxSize,
          decoration: BoxDecoration(
            color: AppColors.IndexLetterBoxBgColor,
            borderRadius: BorderRadius.all(
                Radius.circular(Constants.IndexLetterBoxRadius)),
          ),
          child: Center(
            child: Text(widget._currentLetter,
                style: AppStyles.IndexLetterBoxTextStyle),
          ),
        ),
      ));
    }

    return Stack(
      children: _body,
    );
  }
}
