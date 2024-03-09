import 'package:childfree_romance/Notifiers/all_users_notifier.dart';
import 'package:childfree_romance/Services/image_picker_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid/reorderable_grid.dart';

class ProfilePicturesPage extends StatefulWidget {
  @override
  _ProfilePicturesPageState createState() => _ProfilePicturesPageState();
}

class _ProfilePicturesPageState extends State<ProfilePicturesPage> {
  late AllUsersNotifier _allUsersNotifier;
  late ImagePickerService _imagePickerService;

  @override
  void initState() {
    super.initState();
    _allUsersNotifier = Provider.of<AllUsersNotifier>(context, listen: false);
    _imagePickerService = ImagePickerService(_allUsersNotifier);
  }

  @override
  Widget build(BuildContext context) {
    double? itemSize;
    if (!kIsWeb) {
      itemSize = MediaQuery.of(context).size.width * 0.3;
    } else {
      itemSize = 200.0;
    }

    return Consumer<AllUsersNotifier>(
      builder: (context, notifier, _) {
        final List<Widget> gridItems = List.generate(6, (index) {
          if (index < notifier.profilePictures.length) {
            final url = notifier.profilePictures[index];
            return Container(
              key: ValueKey(url), // Assigning unique key based on URL
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Stack(
                children: [
                  Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: GestureDetector(
                        onTap: () {
                          _imagePickerService.pickAndUploadImage(index);
                          print('Tapped at index $index');
                        },
                        child: Image.network(
                          url,
                          width: itemSize,
                          height: itemSize,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        print('Deleted image at index $index');
                        // Call method to delete image at index
                        notifier.deleteProfilePicture(index);
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 12,
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Assigning a unique key for the empty card
            return Container(
              key: ValueKey('$index'), // Unique key for empty card
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.transparent,
              ),
              child: GestureDetector(
                onTap: () {
                  print('Tapped at index $index');
                  _imagePickerService.pickAndUploadImage(-1);
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 1,
                  child: Center(
                    child: Icon(
                      Icons.add,
                      size: 40.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            );
          }
        });

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: !kIsWeb ? 300 : 500,
              height: !kIsWeb ? 300 : 350,
              child: ReorderableGridView.extent(
                maxCrossAxisExtent: itemSize!,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    notifier.swapProfilePictures(oldIndex, newIndex);
                  });
                },
                childAspectRatio: 1,
                children: gridItems,
              ),
            ),
          ],
        );
      },
    );
  }
}
