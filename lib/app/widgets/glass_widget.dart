import 'dart:ui';

import 'package:flutter/material.dart';



class HoverCardWidget extends StatefulWidget {
  final String image;
  final String title;
  final String slogan;
  final String description;

  const HoverCardWidget(
      {super.key,
      required this.image,
      required this.title,
      required this.slogan,
      required this.description});

  @override
  State<HoverCardWidget> createState() => _HoverCardWidgetState();
}

class _HoverCardWidgetState extends State<HoverCardWidget>
    with SingleTickerProviderStateMixin {
  /// CREATING THE ANIMATION CONTROLLER TO CONTROLLER ANIMATION
  late final AnimationController _controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 300));
  late final Animation<Offset> _animation = Tween<Offset>(
    begin: const Offset(1.1, 0),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ),
  );
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => _controller.forward(),
      onExit: (event) => _controller.reverse(),
      child: ClipRRect(
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          height: 320,
          width: 220,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                        image: NetworkImage(widget.image), fit: BoxFit.cover)),
              ),
              SlideTransition(
                position: _animation,
                child: ClipRRect(
                  clipBehavior: Clip.hardEdge,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// SPACER
                          const Spacer(),

                          /// TITLE
                          TextUtil(
                            text: widget.title,
                            weight: true,
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          /// SLOGAN
                          TextUtil(
                            text: widget.slogan,
                            size: 14,
                            weight: true,
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          /// DESCRIPTION
                          TextUtil(
                            text: widget.description,
                            size: 12,
                            weight: true,
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 35,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: const LinearGradient(colors: [
                                    Colors.red,
                                    Colors.orange,
                                  ])),
                              alignment: Alignment.center,
                              child: const TextUtil(
                                text: "Discover More",
                                size: 12,
                                weight: true,
                              ),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              IgnorePointer(
                child: Container(
                  height: 320,
                  width: 220,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white, width: 4)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TextUtil extends StatelessWidget {
  final String text;
  final Color? color;
  final double? size;
  final bool? weight;
  const TextUtil(
      {super.key, required this.text, this.size, this.color, this.weight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color ?? Colors.white,
          fontSize: size ?? 18,
          fontWeight: weight == null ? FontWeight.normal : FontWeight.w900),
    );
  }
}
