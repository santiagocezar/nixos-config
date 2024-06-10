/*
yeah this is from sodiboo's config too, made a separate file for it
because it looks a bit cleaner.

this does a cross product (yeah let's call it like that) of key modifiers and normal keys
*/

lib:

with lib;

{ suffixes, prefixes, substitutions ? {} }:
let
  replacer = replaceStrings (attrNames substitutions) (attrValues substitutions);
  format = prefix: suffix: let
    actual-suffix =
      if isList suffix.action
      then {
        action = head suffix.action;
        args = tail suffix.action;
      }
      else {
        inherit (suffix) action;
        args = [];
      };

    action = replacer "${prefix.action}-${actual-suffix.action}";
  in {
    name = "${prefix.key}+${suffix.key}";
    value.action.${action} = actual-suffix.args;
  };
  pairs = attrs: fn:
    concatMap (key:
      fn {
        inherit key;
        action = attrs.${key};
      }) (attrNames attrs);
in
  listToAttrs (pairs prefixes (prefix: pairs suffixes (suffix: [(format prefix suffix)])))
