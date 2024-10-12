

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:tpmobile/models/contact.dart';
import 'package:tpmobile/services/database.dart';
import 'package:tpmobile/ui/widgets/Buttons/button_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tpmobile/const/colors.dart';
import 'package:tpmobile/const/text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];
  bool isDark = false;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final loadedContacts = await DatabaseHelper.instance.getContacts();
    setState(() {
      contacts = loadedContacts;
      filteredContacts = loadedContacts;
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
    await FlutterPhoneDirectCaller.callNumber(phoneNumber);
  }

  void _filterContacts(String query) {
    setState(() {
      filteredContacts = contacts.where((contact) {
        return contact.name.toLowerCase().contains(query.toLowerCase()) ||
            contact.pseudoName.toLowerCase().contains(query.toLowerCase()) ||
            contact.phoneNumber.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(
        useMaterial3: true,
        disabledColor: isDark ? Colors.blue : Colors.white,
        brightness: isDark ? Brightness.dark : Brightness.light);

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(
              hintText: 'Search contacts...',
              onChanged: _filterContacts,
              leading: const Icon(Icons.search),
              trailing: [
                Tooltip(
                  message: 'Change brightness mode',
                  child: IconButton(
                    isSelected: isDark,
                    onPressed: () {
                      setState(() {
                        isDark = !isDark;
                      });
                    },
                    icon: const Icon(Icons.wb_sunny_outlined),
                    selectedIcon: const Icon(Icons.brightness_2_outlined),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredContacts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    splashColor: AppColors.primaryColor,
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(color: AppColors.primaryColor),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    title: Text(filteredContacts[index].name),
                    subtitle: Text(filteredContacts[index].pseudoName),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(filteredContacts[index].phoneNumber),
                        InkWell(
                            onTap: () {
                              _showEditContactBottomSheet(
                                  filteredContacts[index], context);
                            },
                            child: const Icon(
                              Icons.edit,
                              color: AppColors.primaryColor,
                            )),
                      ],
                    ),
                    onTap: () {
                      _showContactOptions(filteredContacts[index], context);
                    },
                  ),
                );
              },
            ),
          ),
        ],
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
                title: const Text('Call'),
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
                  final Uri launchUri = Uri(
                    scheme: 'tel',
                    path: contact.phoneNumber,
                  );
                  await launchUrl(launchUri);
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
