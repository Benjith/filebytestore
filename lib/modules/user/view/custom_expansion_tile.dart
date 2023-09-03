import 'package:filebytestore/utils/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gap/gap.dart';

class CustomExpansionTile extends StatefulWidget {
  const CustomExpansionTile(
      {super.key,
      this.title,
      this.leadingText,
      this.leadingColor,
      this.children,
      this.deleteAction,
      this.editAction,
      this.viewAction,
      this.downloadAction,
      this.titlePadding,
      this.firstTitleMaxWidth});
  final String? title;
  final String? leadingText;
  final Color? leadingColor;
  final Widget? children;
  final VoidCallback? deleteAction;
  final VoidCallback? editAction;
  final VoidCallback? viewAction;
  final VoidCallback? downloadAction;
  final double? titlePadding;
  final double? firstTitleMaxWidth;

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: widget.titlePadding ?? 20),
        child: Text(
          (widget.title ?? ""),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: body1Medium.black,
          textAlign: TextAlign.start,
        ),
      ),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      onExpansionChanged: (value) {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      trailing: isExpanded
          ? const Icon(Icons.expand_more)
          : const Icon(Icons.expand_less),
      leading: widget.leadingText == null
          ? Container(
              margin: const EdgeInsets.only(top: 3),
              width: 16,
              height: 16,
              color: widget.leadingColor,
            )
          : Container(
              width: widget.firstTitleMaxWidth ?? double.infinity,
              margin: const EdgeInsets.only(
                top: 3,
              ),
              child: Text(
                widget.leadingText ?? "",
                style: body1Medium.black,
                maxLines: 1,
              ),
            ),
      childrenPadding:
          const EdgeInsets.only(left: 10, bottom: 20, top: 0, right: 5),
      children: [
        if (widget.children != null) ...[widget.children!, const Gap(20)],
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (widget.viewAction != null)
              InkWell(onTap: widget.viewAction, child: const Icon(Icons.list)),
            if (widget.editAction != null)
              InkWell(onTap: widget.editAction, child: const Icon(Icons.edit)),
            const Gap(16),
            if (widget.deleteAction != null)
              InkWell(
                  onTap: widget.deleteAction, child: const Icon(Icons.delete))
          ],
        )
      ],
    );
  }
}

class Information extends StatelessWidget {
  const Information(this.title, this.subtitle,
      {super.key, this.trailingSubtitle});
  final String title;
  final String subtitle;
  final Widget? trailingSubtitle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: caption.grey,
          ),
          const Gap(7),
          trailingSubtitle == null
              ? Text(
                  subtitle,
                  style: body1Medium.black,
                )
              : Row(
                  children: [
                    Text(
                      subtitle,
                      style: body1Medium.black,
                    ),
                    const Gap(2),
                    trailingSubtitle!
                  ],
                ),
        ],
      ),
    );
  }
}
