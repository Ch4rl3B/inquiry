part of 'inquiry.dart';

class InquiryViewModel extends BaseViewModel {
  /// This is used as object to identify a loader
  final String _loading = 'loading';

  /// Set to true if the user has voted
  bool hasVoted;

  /// The option the user voted.
  int? votedOption;

  /// The option the user selected
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

  /// Calculates the total votes for the inquiry.
  int get totalVotes => options.fold(0, (p, e) => p + e.votes);

  /// This method is called when the user taps in an option. If the option was
  /// previously selected the is deselected, in the other case then selects it.
  void tapOption(InquiryOption option) async {
    if (selectedOption == option.id) {
      selectedOption = null;
    } else {
      selectedOption = option.id;
    }
    notifyListeners();
  }

  /// this method is the one who handles the vote. It calls the [onVoted] callback
  /// and if the return is true then changes the voting session to voted.
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
  /// Height of an [InquiryOption].
  /// Defaults to 36.
  final double optionsHeight;

  /// Width of an [InquiryOption].
  /// The width is the same for all options.
  /// If not specified, the width is the width of the inquiry.
  final double? optionsWidth;

  /// Border radius of an [InquiryOption].
  /// Defaults to 0.
  final BorderRadius? optionsBorderRadius;

  /// Border of a [InquiryOption].
  /// The border is the same for all options.
  /// You can define the border for the rightAnswer with [rightAnswerBorder]
  /// Defaults to null.
  final BoxBorder? optionsBorder;

  /// Border of the inquiry's right answer.
  /// Defaults to null.
  final BoxBorder? rightAnswerBorder;

  /// Color of a [InquiryOption].
  /// The color is the same for all options.
  /// Defaults to [Theme.of(context).canvasColor].
  final Color? optionsBackgroundColor;

  /// Color of the background of a [InquiryOption] when the user has voted.
  /// Defaults to [Theme.of(context).canvasColor].
  final Color? wrongBackgroundColor;

  /// Color of the background of a [InquiryOption] when the user has voted.
  /// Defaults to [Theme.of(context).canvasColor].
  final Color? rightBackgroundColor;

  /// Splashes a [InquiryOption] when the user taps it.
  /// Defaults to [Theme.of(context).primaryColorLight].
  final Color? optionsSplashColor;

  /// Radius of the border of a [InquiryOption] when the user has voted.
  /// Defaults to Radius.circular(8).
  final Radius? votedInquiryPercentRadius;

  /// Color of the progress bar of a [InquiryOption] when the user has voted and is not right answer.
  /// Defaults to [ Theme.of(context).colorScheme.error].
  final Color? votedWrongProgressColor;

  /// Color of the progress bar of a [InquiryOption] when the user has voted and is right answer.
  /// Defaults to [Theme.of(context).primaryColor].
  final Color? votedRightProgressColor;

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
    this.optionsHeight = 36,
    this.optionsWidth,
    this.optionsBorderRadius = BorderRadius.zero,
    this.votedInquiryPercentRadius = Radius.zero,
    this.optionsBorder = const Border(),
    this.rightAnswerBorder = const Border(),
    this.optionsBackgroundColor,
    this.wrongBackgroundColor,
    this.rightBackgroundColor,
    this.optionsSplashColor,
    this.votedWrongProgressColor,
    this.votedRightProgressColor,
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
  /// The id of the object. Will be used to identify the object on a list,
  /// and to determine if the object was selected
  /// must be unique in the list.
  final int id;

  /// It can be any widget with an unbounded size that will be shown inside the
  /// Inquiry Option
  final Widget title;

  /// The amount of people that have voted for this option
  int votes;

  /// indicate if this option is the right answer for the inquiry
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
