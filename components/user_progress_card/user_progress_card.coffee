angular.module('diehardFundApp').directive 'userProgressCard', ($translate, $location, Session, Records, IntercomService, ModalService, ChangePictureForm) ->
  scope: {user: '='}
  restrict: 'E'
  templateUrl: 'generated/components/user_progress_card/user_progress_card.html'
  replace: true
  controller: ($scope) ->
    $scope.show = ->
      $scope.user.createdAt.isAfter(moment("2017-05-01")) &&
      !Session.user().hasExperienced("dismissUserProgressCard")

    $scope.activities = [
      translate: "enter_name"
      complete:  -> $scope.user.name?
      click:     -> $location.path '/profile'
    ,
      translate: "set_profile_picture"
      complete:  -> $scope.user.avatarKind != 'initials'
      click:     -> ModalService.open ChangePictureForm
    ,
      translate: "set_bio"
      complete:  -> $scope.user.shortBio?
      click:     -> $location.path '/profile'
    ,
      translate: "join_group"
      complete:  -> $scope.user.groups().length > 0
      click:     -> $location.path '/explore'
    ,
      translate: "make_decision"
      complete:  -> $scope.user.experiences.hasVoted
      click:     -> $location.path '/polls'
    ]

    $scope.translationFor = (key) ->
      $translate.instant("diehard_fund_onboarding.user_progress_card.activities.#{key}")

    $scope.$close = ->
      Records.users.saveExperience("dismissUserProgressCard")
      $scope.dismissed = true

    $scope.setupComplete = ->
      _.all _.invoke($scope.activities, 'complete')
