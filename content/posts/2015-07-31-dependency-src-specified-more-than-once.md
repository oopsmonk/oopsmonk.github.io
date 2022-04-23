---
title: "Dependency src specified more than once"
tags: ["Android", "Chromium"]
date: "2015-07-31 17:50:40 +0800"
---

This problem appered when I was checking out older tag from the Chromium project.  
[Working with Release Branches](https://www.chromium.org/developers/how-tos/get-the-code/working-with-release-branches)  

    ~/chromium_build/src$ git fetch --tags
    ~/chromium_build/src$ git checkout -b tag_35.0.1849.0 35.0.1849.0
    ~/chromium_build/src$ gclient sync --with_branch_heads --jobs 16

Error log:  

    Syncing projects: 100% ( 1/ 1) src

    src (ERROR)
    ----------------------------------------
    [0:00:00] Started.

    ________ running 'git reset --hard HEAD' in '/home/sam.chen/chromium_source/src'
    [0:00:00] HEAD is now at 77bd011 Publish DEPS for Chromium 35.0.1849.0
    [0:00:00] _____ src : Attempting rebase onto 77bd011602b1799f715591e697806c55e7ef8b7f...
    [0:00:00] Current branch tag_35.0.1849.0 is up to date.
    [0:00:00]
    ----------------------------------------
    Error: 1> Dependency src specified more than once:
    1>   src(https://chromium.googlesource.com/chromium/src.git) [https://chromium.googlesource.com/chromium/src.git]
    1> vs
    1>   src(https://chromium.googlesource.com/chromium/src.git) -> src(https://chromium.googlesource.com/chromium/src.git@ae69ae7642
    35ccaac55fc44a3b5f3276ff34cb58) [https://chromium.googlesource.com/chromium/src.git@ae69ae764235ccaac55fc44a3b5f3276ff34cb58]

You need to edit the `.DEPS.git` file, remove the entry 'src' and then `gcient sync --with_branch_heads`.  

    ~/chromium_build/src$ git diff .DEPS.git
    diff --git a/.DEPS.git b/.DEPS.git
    index aa9f7a2a..81e870b 100644
    --- a/.DEPS.git
    +++ b/.DEPS.git
    @@ -31,8 +31,6 @@ deps = {
             Var('git_url') + '/chromium/tools/commit-queue.git@7779c66e03aa5b87a2d7354387b3d16338da9e29',
         'depot_tools':
             Var('git_url') + '/chromium/tools/depot_tools.git@9a8b066e52dff833016db0fcea69072814162ffe',
    -    'src':
    -        Var('git_url') + '/chromium/src.git@ae69ae764235ccaac55fc44a3b5f3276ff34cb58',
         'src/breakpad/src':
             Var('git_url') + '/external/google-breakpad/src.git@d7b5ea03d763b25445c198963034b49596da45f0',
         'src/chrome/browser/resources/pdf/html_office':

    ~/chromium_build/src$ gclient sync --with_branch_heads --jobs 16 --force

Reference:  
https://groups.google.com/a/chromium.org/forum/#!msg/chromium-dev/1iNTFLNjUQo/LgCPaxkbd-4J  

