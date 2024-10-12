import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tpmobile/ui/widgets/Buttons/button_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tpmobile/const/colors.dart';
import 'package:tpmobile/const/text.dart';

class Contact {
  int? id;
  String name;
  String pseudoName;
  String phoneNumber;

  Contact(
      {this.id,
      required this.name,
      required this.pseudoName,
      required this.phoneNumber});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'pseudoName': pseudoName,
      'phoneNumber': phoneNumber,
    };
  }

  static Contact fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      pseudoName: map['pseudoName'],
      phoneNumber: map['phoneNumber'],
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('contacts.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE contacts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        pseudoName TEXT,
        phoneNumber TEXT
      )
    ''');
  }

  Future<int> insertContact(Contact contact) async {
    final db = await database;
    return await db.insert('contacts', contact.toMap());
  }

  Future<List<Contact>> getContacts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('contacts');
    return List.generate(maps.length, (i) => Contact.fromMap(maps[i]));
  }

  Future<int> updateContact(Contact contact) async {
    final db = await database;
    return await db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<int> deleteContact(int id) async {
    final db = await database;
    return await db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final loadedContacts = await DatabaseHelper.instance.getContacts();
    setState(() {
      contacts = loadedContacts;
    });
  }

  Future<void> _addNewContact(Contact newContact) async {
    await DatabaseHelper.instance.insertContact(newContact);
    await _loadContacts();
  }

  Future<void> _editContact(Contact updatedContact) async {
    await DatabaseHelper.instance.updateContact(updatedContact);
    await _loadContacts();
  }

  Future<void> _deleteContact(int id) async {
    await DatabaseHelper.instance.deleteContact(id);
    await _loadContacts();
  }

  void _showAddContactBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AddContactBottomSheet(onContactAdded: _addNewContact);
      },
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            )),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        title: Text('Contacts',
            style: AppTextStyle.headerText.copyWith(
              color: Colors.white,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            SearchBar(
              backgroundColor: WidgetStateProperty.all(AppColors.fieldsColor),
              shadowColor: WidgetStatePropertyAll(AppColors.primaryColor),
              shape: WidgetStateProperty.all(OutlinedBorder(side: BorderSide(
                color: 
              ))),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      splashColor: AppColors.primaryColor,
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(color: AppColors.primaryColor),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      title: Text(contacts[index].name),
                      subtitle: Text(contacts[index].pseudoName),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(contacts[index].phoneNumber),
                          InkWell(
                              onTap: () {
                                _showEditContactBottomSheet(contacts[index], context);
                              },
                              child: const Icon(
                                Icons.edit,
                                color: AppColors.primaryColor,
                              )),
                        ],
                      ),
                      onTap: () {
                        _showContactOptions(contacts[index], context);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          _showAddContactBottomSheet(context);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showContactOptions(Contact contact, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Contact Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              
              ListTile(
                leading: const Icon(
                  Icons.call,
                  color: AppColors.primaryColor,
                ),
                title: const Text(
                  'Call',
                ),
                onTap: () {
                  Navigator.pop(context);
                  _makePhoneCall(contact.phoneNumber);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.message,
                  color: AppColors.primaryColor,
                ),
                title: const Text('Send SMS'),
                onTap: () async {
                  Navigator.pop(context);
                  _makePhoneCall(contact.phoneNumber);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete,
                  color: AppColors.primaryColor,
                ),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteContact(contact.id!);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditContactBottomSheet(Contact contact, BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AddContactBottomSheet(
          onContactAdded: (updatedContact) {
            updatedContact.id = contact.id;
            _editContact(updatedContact);
          },
          initialContact: contact,
        );
      },
    );
  }
}

class AddContactBottomSheet extends StatefulWidget {
  final Function(Contact) onContactAdded;
  final Contact? initialContact;

  const AddContactBottomSheet({
    Key? key,
    required this.onContactAdded,
    this.initialContact,
  }) : super(key: key);

  @override
  _AddContactBottomSheetState createState() => _AddContactBottomSheetState();
}

class _AddContactBottomSheetState extends State<AddContactBottomSheet> {
  late TextEditingController _nameController;
  late TextEditingController _pseudoNameController;
  late TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.initialContact?.name ?? '');
    _pseudoNameController =
        TextEditingController(text: widget.initialContact?.pseudoName ?? '');
    _phoneNumberController =
        TextEditingController(text: widget.initialContact?.phoneNumber ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _pseudoNameController,
            decoration: const InputDecoration(labelText: 'Pseudo Name'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _phoneNumberController,
            decoration: const InputDecoration(labelText: 'Phone Number'),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ButtonWidget(
                buttonText: widget.initialContact == null
                    ? 'Add Contact'
                    : 'Update Contact',
                onClick: () {
                  final newContact = Contact(
                    name: _nameController.text,
                    pseudoName: _pseudoNameController.text,
                    phoneNumber: _phoneNumberController.text,
                  );
                  widget.onContactAdded(newContact);
                  Navigator.pop(context);
                }),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _pseudoNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }
}
