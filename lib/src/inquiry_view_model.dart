part of 'inquiry.dart';

class InquiryViewModel extends BaseViewModel {
  /// This is used as object to identify a loader
  final String _loading = 'loading';

  /// Set to true if the user has voted
  bool hasVoted;

  int? votedOption;

  int? selectedOption;

  final List<InquiryOption> options;

  InquiryViewModel({
    required this.options,
    this.onVoted,
    required this.hasVoted,
    this.votedOption,
  });

  bool get isLoading => busy(_loading);

  final Future<bool> Function(InquiryOption inquiryOption, int newTotalVotes)?
      onVoted;

  void initialise() {
    if (hasVoted) {
      assert(votedOption != null);
    }
  }

  int get totalVotes => options.fold(0, (p, e) => p + e.votes);

  void tapOption(InquiryOption option) async {
    if (selectedOption == option.id) {
      selectedOption = null;
    } else {
      selectedOption = option.id;
    }
    notifyListeners();
  }

  void vote() async {
    bool response = true;
    final option =
        options.firstWhere((element) => element.id == selectedOption);
    if (onVoted != null) {
      response = await runBusyFuture(onVoted!.call(option, option.votes + 1),
          busyObject: _loading);
    }
    if (response) {
      votedOption = selectedOption!;
      hasVoted = true;
      notifyListeners();
    }
  }
}

class InquiryStyle {
  /// Width of a [Inquiry].
  /// Defaults to `double.infinity`.
  final double? width;

  /// Height of a [Inquiry].
  /// If not specified, the height is `double.infinity`.
  final double? heigh;

  /// Height of an [InquiryOption].
  /// Defaults to 36.
  final double inquiryOptionsHeight;

  /// Width of an [InquiryOption].
  /// The width is the same for all options.
  /// If not specified, the width is the width of the inquiry.
  final double? inquiryOptionsWidth;

  /// Border radius of an [InquiryOption].
  /// Defaults to 0.
  final BorderRadius? inquiryOptionsBorderRadius;

  /// Border of a [InquiryOption].
  /// The border is the same for all options.
  /// You can define the border for the rightAnswer with [inquiryRightAnswerBorder]
  /// Defaults to null.
  final BoxBorder? inquiryOptionsBorder;

  /// Border of the inquiry's right answer.
  /// Defaults to null.
  final BoxBorder? inquiryRightAnswerBorder;

  /// Color of a [InquiryOption].
  /// The color is the same for all options.
  /// Defaults to [Theme.of(context).canvasColor].
  final Color? inquiryOptionsBackgroundColor;

  /// Color of the background of a [InquiryOption] when the user has voted.
  /// Defaults to [Theme.of(context).canvasColor].
  final Color? inquiryWrongBackgroundColor;

  /// Color of the background of a [InquiryOption] when the user has voted.
  /// Defaults to [Theme.of(context).canvasColor].
  final Color? inquiryRightBackgroundColor;

  /// Splashes a [InquiryOption] when the user taps it.
  /// Defaults to [Theme.of(context).primaryColorLight].
  final Color? inquiryOptionsSplashColor;

  /// Radius of the border of a [InquiryOption] when the user has voted.
  /// Defaults to Radius.circular(8).
  final Radius? votedInquiryPercentRadius;

  /// Color of the progress bar of a [InquiryOption] when the user has voted and is not right answer.
  /// Defaults to [ Theme.of(context).colorScheme.error].
  final Color? votedWrongProgressColor;

  /// Color of the progress bar of a [InquiryOption] when the user has voted and is right answer.
  /// Defaults to [Theme.of(context).primaryColor].
  final Color? votedRightProgressColor;

  /// Color of the leading progress bar of a [InquiryOption] when the user has voted.
  /// Defaults to [Theme.of(context).colorScheme.secondary].
  final Color? leadingVotedProgessColor;

  /// Color of the background of a [InquiryOption] when the user clicks to vote and its still in progress.
  /// Defaults to [Theme.of(context).colorScheme.primaryColorLight].
  final Color? voteInProgressColor;

  /// TextStyle of the percentage of a [InquiryOption] when the user has voted.
  final TextStyle? votedPercentageTextStyle;

  /// Animation duration of the progress bar of the [InquiryOption]'s when the user has voted.
  /// Defaults to 1000 milliseconds.
  /// If the animation duration is too short, the progress bar will not animate.
  /// If you don't want the progress bar to animate, set this to 0.
  final int votedAnimationDuration;

  /// The height between the title and the options.
  /// The default value is 12.
  final double heightBetweenTitleAndOptions;

  /// The height between the options.
  /// The default value is 8.
  final double heightBetweenOptions;

  /// The height between the options and the Metadata.
  /// The default value is 8.
  final double heightBetweenOptionsAndMeta;

  /// [votesTextStyle] is the text style of the [votesText] text and [totalVotes].
  /// If not specified, the default text style is used.
  final TextStyle? votesTextStyle;

  /// The Inquiry's [Column] alignment on horizontal axis
  /// default [CrossAxisAlignment.center]
  final CrossAxisAlignment crossAxisAlignment;

  /// The Inquiry's [Column] alignment on vertical axis
  /// default [CrossAxisAlignment.start]
  final MainAxisAlignment mainAxisAlignment;

  /// The style for the [ElevatedButton] that triggers the vote action
  /// preferentially to be an ElevatedButton.style
  /// default:
  /// ```
  ///  ElevatedButton.styleFrom(
  ///    backgroundColor: Colors.transparent,
  ///    shadowColor: Colors.transparent,
  ///    textStyle: TextStyle(
  ///       fontSize: 14,
  ///       color: Theme.of(context).primaryColor,
  ///       fontWeight: FontWeight.w500,
  ///     ),
  ///  )
  /// ```
  final ButtonStyle? voteButtonStyle;

  const InquiryStyle({
    this.width = double.infinity,
    this.heigh = double.infinity,
    this.inquiryOptionsHeight = 36,
    this.inquiryOptionsWidth = double.infinity,
    this.inquiryOptionsBorderRadius = BorderRadius.zero,
    this.votedInquiryPercentRadius = Radius.zero,
    this.inquiryOptionsBorder = const Border(),
    this.inquiryRightAnswerBorder = const Border(),
    this.inquiryOptionsBackgroundColor,
    this.inquiryWrongBackgroundColor,
    this.inquiryRightBackgroundColor,
    this.inquiryOptionsSplashColor,
    this.votedWrongProgressColor,
    this.votedRightProgressColor,
    this.leadingVotedProgessColor,
    this.voteInProgressColor,
    this.votedPercentageTextStyle = const TextStyle(
      fontSize: 14,
    ),
    this.votedAnimationDuration = 0,
    this.heightBetweenTitleAndOptions = 12,
    this.heightBetweenOptions = 8,
    this.heightBetweenOptionsAndMeta = 8,
    this.votesTextStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.voteButtonStyle,
  });
}

class InquiryOption {
  final int id;
  final Widget title;
  int votes;
  bool rightAnswer;

  InquiryOption({
    required this.id,
    required this.title,
    required this.votes,
    this.rightAnswer = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InquiryOption &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
