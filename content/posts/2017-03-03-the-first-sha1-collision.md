---
title: "The First SHA1 Collision"
tags: ["git", "Linux"]
date: "2017-03-03 09:44:13 +0800"
---

[CWI Institute in Amsterdam](https://www.cwi.nl/) and Google genrate two PDF documents with the same SHA-1 digest.   
Google security blog - [Announcing the first SHA1 collision](https://security.googleblog.com/2017/02/announcing-first-sha1-collision.html)  

## SHA-1 collistion and Git  

### If a file A with X hash in local repository and with X hash in remote (SHA-1 collistion between local and remote), would overwrite the local version?  

> Nope. If it has the same SHA1, it means that when we receive the object from the other end, we will _not_ overwrite the object we already have.  
> So you have two cases of collision:  
> the inadvertent kind, ...  
> The attacker kind ...  
> ...  
> So in this case, the collision is entirely a non-issue: you'll get a "bad" repository that is different from what the attacker intended, but since you'll never actually use his colliding object, it's _literally_ no different from the attacker just not having found a collision at all, but just using the object you already had (ie it's 100% equivalent to the "trivial" collision of the identical file generating the same SHA1).  
> See above. The only _dangerous_ kind of collision is the inadvertent kind, but that's obviously also the very very unlikely kind.  
> Torvalds @ [Git- Re: Starting to think about sha-256?](http://marc.info/?l=git&m=115678778717621&w=2)   

### Will Git under attack? 

> I haven't seen the attack yet, but git doesn't actually just hash the data, it does prepend a type/length field to it. That usually tends to make collision attacks much harder, because you either have to make the resulting size the same too, or you have to be able to also edit the size field in the header.  
> pdf's don't have that issue, they have a fixed header and you can fairly arbitrarily add silent data to the middle that just doesn't get shown.  
> ...  
> Put another way: I doubt the sky is falling for git as a source control management tool. Do we want to migrate to another hash? Yes.  Is it "game over" for SHA1 like people want to say? Probably not.   
> I haven't seen the attack details, but I bet  
> (a) the fact that we have a separate size encoding makes it much harder to do on git objects in the first place  
> (b) we can probably easily add some extra sanity checks to the opaque data we do have, to make it much harder to do the hiding of random data that these attacks pretty much always depend on.  
> Torvalds @ [Git- Re: SHA1 collisions found](http://marc.info/?l=git&m=148787047422954&w=2)  

### Which one will be the next algorithm? SHA-256, SHA-3-256, and BLAKE2b-256 

> I've mentioned this on the list earlier, but here are the contenders in
my view:  
> SHA-256:  
>   Common, but cryptanalysis has advanced.  Preimage resistance (which is even more important than collision resistance) has gotten to 52 of 64 rounds.  Pseudo-collision attacks are possible against 46 of 64 rounds.  Slowest option.  
> SHA-3-256:  
>   Less common, but has a wide security margin.  Cryptanalysis is ongoing, but has not advanced much.  Somewhat to much faster than SHA-256, unless you have SHA-256 hardware acceleration (which almost nobody does).  
> BLAKE2b-256:  
>   Lower security margin, but extremely fast (faster than SHA-1 and even MD5).  
> 
> My recommendation has been for SHA-3-256, because I think it provides the best tradeoff between security and performance.  
> brian m. carlson @ [Git- Re: SHA1 collisions found](http://marc.info/?l=git&m=148813076820272&w=2)  


> So SHA256 acceleration is mainly an ARM thing, and nobody develops on ARM because there's effectively no hardware that is suitable for developers. Even ARM people just use PCs (and they won't be Goldmont Atoms).  
> Reduced-round SHA256 may have been broken, but on the other hand it's been around for a lot longer too, so ...  
> But yes, SHA3-256 looks like the sane choice. Performance of hashing is important in the sense that it shouldn't _suck_, but is largely secondary. All my profiles on real loads (well, *my* real loads) have shown that zlib performance is actually much more important than SHA1.   
>  Torvalds @ [Git- Re: SHA1 collisions found](http://marc.info/?l=git&m=148813685721500&w=2)  


## Reference:  
[shattered.io](https://shattered.io/)  
[The first collision for full SHA-1](https://shattered.io/static/shattered.pdf)  
[Git - Re: SHA1 collisions found](http://marc.info/?t=148786884600001&r=1&w=2)  

