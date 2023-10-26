angular.module('app', [])
    .controller('AppCtrl', function() {
        var vm = this;
        vm.side = 'left';
        vm.move = function() {
            vm.side = vm.side == 'left' ? 'right' : 'left';
        }
    })
    .directive('move', function() {
        return {
            restrict: 'A',
            scope: { move: '=' },
            link: function(scope, element, attrs, controller) {
                scope.$watch('move', function(side) {
                    angular.element(element).addClass(side);
                    var toRemove = side == 'left' ? 'right' : 'left';
                    angular.element(element).removeClass(toRemove);
                })
            }
        }
    })