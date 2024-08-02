import 'package:flutter/material.dart';

class ModalBottomSheetScaffoldWrapper extends StatelessWidget {
  const ModalBottomSheetScaffoldWrapper({
    super.key,
    required this.child,
    this.firstIcon,
    this.secondIcon,
    required this.title,
    this.firstOnPressed,
    this.secondOnPressed,
  });
  final Widget child;
  final Widget? firstIcon;
  final Widget? secondIcon;
  final String title;
  final VoidCallback? firstOnPressed;
  final VoidCallback? secondOnPressed;
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Container(
                      width: 30,
                      height: 4,
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF989CAD),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 50),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          if (firstIcon != null)
                            InkWell(
                              onTap: firstOnPressed,
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: firstIcon,
                                ),
                              ),
                            )
                          else
                            const SizedBox(
                              width: 50,
                              height: 50,
                            ),
                          const Spacer(),
                          Text(
                            title,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          if (secondIcon != null)
                            InkWell(
                              onTap: secondOnPressed,
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: secondIcon,
                                ),
                              ),
                            )
                          else
                            const SizedBox(
                              width: 50,
                              height: 50,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: child),
          ],
        ),
      );
}
