import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:stacked/stacked.dart';

part 'inquiry_view_model.dart';

class Inquiry extends StackedView<InquiryViewModel> {
  /// An asynchronous callback for HTTP call feature
  /// Called when the user select an option and hit vote.
  /// The the option that the user voted for is passed as an argument.
  /// If the callback returns true, the tapped [InquiryOption] is considered as right answer.
  final Future<bool> Function(InquiryOption pollOption, int newTotalVotes)?
      onVoted;

  /// The title of the poll. Can be any widget with a bounded size.
  final Widget? titleWidget;

  /// The id of the inquiry.
  /// This id is used to identify the inquiry
  /// to check if a user has already voted in this inquiry.
  final String? inquiryId;

  /// Checks if a user has already voted in this inquiry.
  /// If this is set to true, the user can't vote
  /// [votedOptionId] must also be provided if this is set to true.
  ///
  /// Default value is `false`.
  final bool hasVoted;

  /// Id of the option if the user has voted on this inquiry.
  /// It is ignored if [hasVoted] is set to false or not set at all.
  final int? userVotedOptionId;

  /// Data class format for the inquiry options.
  /// The list can have any number of elements.
  /// Pptions are displayed in the order they are in the list.
  /// example:
  /// ```
  /// inquiryOptions = [
  ///  InquiryOption(id: 1, title: Text('Option 1'), votes: 2),
  ///  InquiryOption(id: 2, title: Text('Option 2'), votes: 5),
  ///  InquiryOption(id: 3, title: Text('Option 3'), votes: 9),
  ///  InquiryOption(id: 4, title: Text('Option 4'), votes: 2),
  /// ]
  /// ```
  /// The [id] of each option is used to identify the option when the user votes.
  /// The [title] of each option that is displayed to the user. Can be any widget with a bounded size.
  /// The [votes] of each option is the number of votes that the option has received so far.
  /// The [rightAnswer] of each option indicates is the option is the right one.
  final List<InquiryOption> options;

  /// The text that shows the amount of votes for each option.
  /// If not specified, the english word "Votes" is used.
  final String? votesText;

  /// The text to show in the button to vote.
  /// If not specified, the english word "Vote" is used.
  final String? voteButtonText;

  /// [metadataWidget] is displayed at the bottom of the poll.
  /// It can be any widget with an unbounded size.
  /// example:
  /// `metadataWidget: Text('Created by: $createdBy')`
  final Widget? metadataWidget;

  /// Loading animation widget for [InquiryOption] when [onVoted] callback is invoked
  /// Defaults to [CircularProgressIndicator]
  /// Is visible until the [onVoted] execution is completed,
  final Widget? loadingWidget;

  /// The style for the [Inquiry] and [InquiryOptions]
  /// Feel free to personalize the inquiry to your app designs
  final InquiryStyle style;

  const Inquiry({
    super.key,
    this.onVoted,
    this.titleWidget,
    this.inquiryId,
    this.hasVoted = false,
    this.userVotedOptionId,
    required this.options,
    this.votesText = 'Votes',
    this.metadataWidget,
    this.loadingWidget,
    this.voteButtonText,
    this.style = const InquiryStyle(),
  });

  @override
  Widget builder(
    BuildContext context,
    InquiryViewModel viewModel,
    Widget? child,
  ) {
    return Column(
      crossAxisAlignment: style.crossAxisAlignment,
      mainAxisAlignment: style.mainAxisAlignment,
      key: inquiryId != null ? ValueKey(inquiryId) : UniqueKey(),
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          visible: titleWidget != null,
          child: titleWidget ?? const SizedBox(),
        ),
        Visibility(
          visible: titleWidget != null,
          child: SizedBox(height: style.heightBetweenTitleAndOptions),
        ),
        ...options.map(
          (option) {
            final selected = option.id == viewModel.selectedOption;
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Visibility(
                visible: viewModel.hasVoted,
                replacement: Container(
                  key: UniqueKey(),
                  margin: EdgeInsets.only(
                    bottom: style.heightBetweenOptions,
                  ),
                  child: InkWell(
                    onTap: () {
                      viewModel.tapOption(option);
                    },
                    splashColor: style.optionsSplashColor,
                    borderRadius: style.optionsBorderRadius,
                    child: Container(
                      height: style.optionsHeight,
                      width: style.optionsWidth ??
                          MediaQuery.of(context).size.width,
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        color: selected
                            ? style.voteInProgressColor
                            : style.optionsBackgroundColor,
                        border: style.optionsBorder,
                        borderRadius: style.optionsBorderRadius,
                      ),
                      child: Center(
                          child: Visibility(
                        visible: viewModel.isLoading && selected,
                        replacement: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              value: viewModel.selectedOption,
                              groupValue: option.id,
                              onChanged: (_) {
                                viewModel.tapOption(option);
                              },
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: option.title,
                            ),
                          ],
                        ),
                        child: Center(
                          child: loadingWidget ??
                              const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                        ),
                      )),
                    ),
                  ),
                ),
                child: Container(
                  key: UniqueKey(),
                  margin: EdgeInsets.only(
                    bottom: style.heightBetweenOptions,
                  ),
                  child: LinearPercentIndicator(
                    width: style.optionsWidth,
                    lineHeight: style.optionsHeight,
                    barRadius: style.votedInquiryPercentRadius,
                    padding: EdgeInsets.zero,
                    percent: viewModel.totalVotes == 0
                        ? 0
                        : option.votes / viewModel.totalVotes,
                    animation: true,
                    animationDuration: style.votedAnimationDuration,
                    backgroundColor: selected
                        ? style.rightBackgroundColor
                        : style.wrongBackgroundColor,
                    progressColor: option.rightAnswer
                        ? style.votedRightProgressColor ??
                            Theme.of(context).primaryColor
                        : style.votedWrongProgressColor ??
                            Theme.of(context).colorScheme.error,
                    center: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          option.title,
                          const SizedBox(
                            width: 4,
                          ),
                          if (selected)
                            const Icon(
                              Icons.check_circle_outline_rounded,
                              color: Colors.black,
                              size: 16,
                            ),
                          const Spacer(),
                          Text(
                            option.votes.toString(),
                            style: style.votedPercentageTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        if (!viewModel.hasVoted)
          SizedBox(height: style.heightBetweenOptionsAndMeta),
        Visibility(
          visible: !viewModel.hasVoted,
          child: ElevatedButton(
            onPressed: viewModel.isLoading || viewModel.selectedOption == null
                ? null
                : viewModel.vote,
            style: style.voteButtonStyle ??
                ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Theme.of(context).primaryColor,
                  shadowColor: Colors.transparent,
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            child: Text(
              voteButtonText ?? 'Vote',
            ),
          ),
        ),
        SizedBox(height: style.heightBetweenOptionsAndMeta),
        Text(
          '${viewModel.totalVotes} $votesText',
          style: style.votesTextStyle,
        ),
        Visibility(
          visible: metadataWidget != null,
          child: metadataWidget ?? const SizedBox(),
        ),
      ],
    );
  }

  @override
  InquiryViewModel viewModelBuilder(BuildContext context) {
    return InquiryViewModel(
      onVoted: onVoted,
      hasVoted: hasVoted,
      votedOption: userVotedOptionId,
      options: options,
    );
  }

  @override
  bool get reactive => true;

  @override
  bool get createNewViewModelOnInsert => true;

  @override
  void onDispose(InquiryViewModel viewModel) {
    viewModel.dispose();
  }

  @override
  void onViewModelReady(InquiryViewModel viewModel) {
    viewModel.initialise();
  }
}
