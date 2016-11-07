angular.module('loomioApp').config ($provide) ->
  $provide.decorator '$controller', ($delegate, $rootScope, $timeout, Session) ->
    ->
      ctrl = $delegate arguments...
      if _.get(arguments, '[1].$router.name') == 'groupPage'

        ctrl.addLauncher(=>
          $timeout -> $rootScope.$broadcast 'launchIntroCarousel'
          true
        , ->
          ctrl.group.isParent() &&
          Session.user().isMemberOf(ctrl.group) &&
          !Session.user().hasExperienced("introductionCarousel") &&
          ctrl.group.createdAt.isAfter(moment("2016-10-31"))
        , priority: 15)

      ctrl
