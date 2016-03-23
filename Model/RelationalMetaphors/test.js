var webppl = require("/usr/local/lib/node_modules/webppl/src/main.js");
var __runner__ = function (t) {
    while (t) {
      t = t()
    }
  };
function printWebPPLValue(x) {
  if (isErp(x)) {
    x.print();
  } else {
    console.log(x);
  }
};
function topK(s,x) {
  console.log('\n* Program return value:\n');
  printWebPPLValue(x);
};
var main = (function (p) {
    return function (runTrampoline) {
        return function (s, k, a) {
            var t = p(s, k, a);
            runTrampoline(t);
        };
    };
}(function (globalStore, _k0, _address0) {
    var map_helper = function map_helper(globalStore, _k138, _address60, i, j, f) {
        var n = ad.add(ad.sub(j, i), 1);
        return function () {
            return ad.eq(n, 0) ? _k138(globalStore, []) : ad.eq(n, 1) ? f(globalStore, function (globalStore, _result139) {
                return function () {
                    return _k138(globalStore, [_result139]);
                };
            }, _address60.concat('_21'), i) : function (globalStore, n1) {
                return function () {
                    return map_helper(globalStore, function (globalStore, _result140) {
                        return function () {
                            return map_helper(globalStore, function (globalStore, _result141) {
                                return function () {
                                    return _k138(globalStore, _result140.concat(_result141));
                                };
                            }, _address60.concat('_23'), ad.add(i, n1), j, f);
                        };
                    }, _address60.concat('_22'), i, ad.sub(ad.add(i, n1), 1), f);
                };
            }(globalStore, ad.maths.ceil(ad.div(n, 2)));
        };
    };
    var map = function map(globalStore, _k136, _address61, fn, l) {
        return function () {
            return map_helper(globalStore, _k136, _address61.concat('_25'), 0, ad.sub(l.length, 1), function (globalStore, _k137, _address62, i) {
                return function () {
                    return fn(globalStore, _k137, _address62.concat('_24'), l[i]);
                };
            });
        };
    };
    var numbers = [
        1,
        4,
        9
    ];
    return function () {
        return map(globalStore, function (globalStore, newDoubles) {
            return function () {
                return _k0(globalStore, newDoubles);
            };
        }, _address0.concat('_126'), function (globalStore, _k1, _address138, num) {
            return function () {
                return _k1(globalStore, ad.mul(num, 2));
            };
        }, numbers);
    };
}));

main(__runner__)({}, topK, '');