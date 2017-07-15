angular.module('diehardFundApp').directive 'groupProgressCard', ($translate, Session, Records, IntercomService, ModalService, GroupModal, CoverPhotoForm, LogoPhotoForm, InvitationModal, DiscussionForm, PollCommonStartModal) ->
  scope: { group: '=?', discussion: '=?' }
  restrict: 'E'
  templateUrl: 'generated/components/group_progress_card/group_progress_card.html'
  replace: true
  controller: ($scope) ->
    $scope.group = $scope.group || $scope.discussion.group()

    $scope.show = ->
      $scope.group.createdAt.isAfter(moment("2016-10-18")) &&
      $scope.group.isParent() &&
      Session.user().isAdminOf($scope.group) &&
      !Session.user().hasExperienced("dismissProgressCard", $scope.group)

    $scope.activities = [
      translate: "set_description"
      complete:  -> $scope.group.description
      click:     -> ModalService.open GroupModal, group: -> $scope.group
    ,
      translate: "set_logo"
      complete:  -> $scope.group.logoUrl() != '/img/default-logo-medium.png'
      click:     -> ModalService.open LogoPhotoForm, group: -> $scope.group
    ,
      translate: "set_cover_photo"
      complete:  -> $scope.group.hasCustomCover
      click:     -> ModalService.open CoverPhotoForm, group: -> $scope.group
    ,
      translate: "invite_people_in"
      complete:  -> $scope.group.membershipsCount > 1 or $scope.group.invitationsCount > 0
      click:     -> ModalService.open InvitationForm, group: -> $scope.group
    ,
      translate: "start_thread"
      complete:  -> $scope.group.discussionsCount > 2
      click:     -> ModalService.open DiscussionForm, discussion: -> Records.discussions.build(groupId: $scope.group.id)
    ,
      translate: "make_decision"
      complete:  -> $scope.group.pollsCount > 1
      click:     -> ModalService.open PollCommonStartModal, poll: -> Records.polls.build(groupId: $scope.group.id)
    ]

    $scope.translationFor = (key) ->
      $translate.instant("diehard_fund_onboarding.group_progress_card.activities.#{key}")

    $scope.$close = ->
      Records.memberships.saveExperience("dismissProgressCard", Session.user().membershipFor($scope.group))
      $scope.dismissed = true

    $scope.setupComplete = ->
      _.all _.invoke($scope.activities, 'complete')
