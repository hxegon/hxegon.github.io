+++
title = 'Blog Setup using hugo, nix and just'
date = 2024-04-10T11:37:36-04:00
draft = false
+++

I want this blog to be a home for more polished versions of my notes.
It's an excuse for me to dive deeper, and a way to give some projects of mine a "finish line" of sorts in the form of retrospectives. After all, pics or it didn't happen.

<!--more-->

## Requirements
- Be easy to use / publish
- Don't make me run a server
- Syntax highlighting
- live preview mode
- Don't make me do frontend
- *TODO*: Handle .org format markup

[Hugo](https://gohugo.io/) can handle all of these. It's a [static site generator](https://en.wikipedia.org/wiki/Static_site_generator), meaning that behind the scenes everything works by looking up html or css files internally. These are pretty easy to host through [github pages](https://pages.github.com/).

Hugo also has built in syntax highlighting, lots of [themes](https://themes.gohugo.io/) (this one is [poison](https://themes.gohugo.io/themes/poison/)) and `hugo serve` has live reload built in.

I'll add a post or edit this one to explain using .org markup at a later date.

## Project dependencies

The dependencies I have for this are only `hugo` and `just`, because the `poison` theme doesn't make use of any javascript dependencies.

I've recently switched using Nix, because I frequently hop between computers and distros and I'm tired of setting up my dev environment multiple times a year. Among other things, I discovered that you can use something called a project flake to manage dependencies for a repository, and I'm using that for this blog.

It would be pretty easy to manage without this, but I'm trying to use these everywhere because I've been burned too many times diving into codebases where nobody knows what node version we're supposed to be using, or stuff mysteriously breaks because a system package isn't the same version on different people's machines. Nix fixes this problem and I will be shamelessly shilling it so I can hopefully stop running into these problems in the future.

The only thing this flake does is supply `just` and `hugo` in your dev environment:
```nix
# flake.nix
{
  description = "My blog";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system}; # not best practice
      buildInputs = with pkgs; [ hugo just ]; # Here
    in {};
}
```

In combination with the [direnv](https://direnv.net/) and a `.envrc` file, you can automatically install and load them when you enter the directory.
direnv has support for flakes built in, and flakes get cached so it's very quick after the first load. Here's the whole `.envrc`:
```
use flake
```

## Just (A make alternative)
[Just](https://github.com/casey/just) is a simple task runner I've been using for _everything_. I think the pleasant syntax of the `justfile` speaks for itself.
```justfile
# A hidden default task so it lists commands when you call just with no args
_default:
    @just --list

# Build the blog, including drafts
build-drafts:
    hugo

# Build the blog every time a file changes, including drafts
serve:
    hugo server --buildDrafts

# Create a new post
new-post NAME:
    hugo new content posts/{{NAME}}.md
```

`make`'s syntax is hard for me to remember, and it has a lot of quirks I've shot myself in the foot with. Just gets out of the way while still offering a lot of power when you need to reach for it. I have a `justfile` for an OCaml project that shows off a lot more of the features, I should make a post about that.

## Github pages

Github can host a static site at `<your-github-username>.github.io`, and there are a lot of great options for doing so.
This blog works from github actions, meaning that once I push the code for my blog it will go through a process described [in this yaml file](https://github.com/hxegon/hxegon.github.io/blob/main/.github/workflows/hugo.yaml) that uses hugo to generate the blog pages.

After that the deployment is as simple as `git push`.

Now that that's done, hopefully I can actually write some articles instead of scratching the itch to make this work with a knowledge management system like org-roam or obsidian...

**This blog's code is hosted [here](https://github.com/hxegon/hxegon.github.io/blob/main/.github/workflows/hugo.yaml) if you want to take a peek.**

## TODO:

- [ ] I'd love to write posts in org mode, and I've heard there's a way to do that with hugo.
- [ ] Having code embedded into a post from a github link, to keep the post in sync with the code.
- [ ] a pre-commit hook for spell checking
- [ ] Automatic cross post to (the social network formerly known as) twitter or mastadon
