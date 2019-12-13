# GitHub Trip Report

(22) By drh on 2019-11-27 15:09:20 and edited on 2019-12-02 01:07:22 [link](https://fossil-scm.org/forum/forumpost/ed0315ff92)

I, the founder of Fossil, was invited and attended the first meeting of the GitHub Open Source Advisory Board in San Francisco on 2019-11-12. This post is a report of my adventures.

## The only skeptic in the room

GitHub was a very gracious host, providing lunch before and dinner after the 5-hour meeting.

There were 24 people in the room, 5 or 6 of whom were GitHub employees. To nobody's surprise, I was the only Git skeptic present. But everyone was very cordial and welcoming. It was a productive meeting.

## It is not about Git

The GitHub employees seem to have all read at least some of my writings concerning Git and rebase and comparing Git and Fossil and so they knew where I stand on those issues. They are not in 100% agreement with me, but they also seem to understand and appreciate my point of view. They all seemed to agree that Git has UX issues and that it is not the optimal Distributed Version Control System (DVCS) design. Their argument is that none of that matters, at least not any more. Git is used by nearly everyone and is the defacto standard, and so that is what they use. Though I disagree, it is still a reasonable argument.

I offered a number of suggestions on how Git might be improved (for example, by adding the ability to check-in revisions to comments on prior check-ins) and their response was mostly "We don't control Git". I replied that GitHub designed and implement the v2-http sync protocol used by Git which has since become the only sync protocol that most Git user will ever experience and which significantly improved the usability of Git. I encouraged them to continue to try to push Git to improve. I'm not sure how persuasive my arguments were though.

Because: It isn't really about Git anymore. GitHub used to be a Git repository hosting company. But now, they are about providing other software development and management infrastructure that augments the version control. They might as well change their name to Hub at this point.

For example, the main topics of discussion at this meeting where:

1. Issue tracking and tickets
2. Code review
3. Automated Continuous Integration
4. Maintainer workflow and triage

The GitHub staff says that the four pillars of their organization are

1. DevOps
2. Security
3. Collaboration
4. Insights

You will notice that version control is not on either of those lists. There has been a culture shift at GitHub. They are now all about the tooling that supports Git and not Git itself.

On the other hand, GitHub showed no hint of any desire to support alternative version control systems like Mercurial or Fossil. They openly assume that Open Source (mostly) runs on Git. It is just that the version control is no longer their focus. They have moved on to providing other infrastructure in support of Open Source.

## Other Take-Aways
### Documentation Is The Best Way To Say "No"

One of the most important and also the hardest jobs of a project maintainer is saying "no" to enhancement requests. If you try to take on every requested enhancement, your project will quickly loss focus and become too unwieldy to maintain. Participant "Paris" (whose full contact information I was unable to obtain) says: "Documentation is the best way to say 'no'." In other words, it is important to document why a project does things the way it does, as this will tend to prevent enhancement requests that cause the project to diverge from its original intent. I have also found that writing about the "why" tends to help one focus on the real purpose of the project as well.

Separately it was observed that documentation is the single most important factor in open-source adaption. The better your documentation, the more likely people are to use and contribute to your project.

Implications for Fossil:

1. I'd like to add the ability to include [PIC](https://en.wikipedia.org/wiki/Pic_language) and [EQN](https://en.wikipedia.org/wiki/Eqn_(software)) markup in the middle of both Markdown and Fossil-Wiki documents.
2. I think this Forum feature has been very successful, but there are still many opportunities to improve the UX.

Additional ideas on how Fossil might be enhanced to support better project documentation are welcomed.
### "The Tools Make The Rules"

This quote (from Tom Ted Kremenek of the Swift project) is saying that your workflow will be defined and constrained by the tools you use. If you use inferior tools your productivity will suffer.

This is the argument I've made for years about the importance of being about to amend check-in comments and to view the descendants of check-ins. Git partisans offer all kinds of excuses about how their workflow does not need that. I tend to counter with "I never needed bisect until I had the capability." The point is that once you have the ability to amend check-in comments and view the descendants of a check-in, your workflow becomes more efficient and you wonder how you ever survived without those capabilities.

What limitations or restrictions in Fossil are limiting productivity? Some possible ideas:

1. Poor tracking of files across renames
2. Inability to do shallow clones
3. Poor ticket UX
4. Inability to subscribe to notifications for changes to specific tickets or files.
5. Difficulty implementing actions that are triggered by new check-ins and/or new tickets. This is needed for Continuous Integration (CI). Enhancements to the [backoffice](https://www.fossil-scm.org/fossil/doc/trunk/www/backoffice.md) feature of Fossil would be welcomed.

### General agreement that rebasing is not a good thing

Even among Git partisans, there seems to be a general agreement that rebase ought to be avoided. The [Rebase Considered Harmful](https://www.fossil-scm.org/fossil/doc/trunk/www/rebaseharm.md) document is not especially controversial.

An interesting insight from the LLVM developers: They use rebase extensively. But the reason is that downstream tooling controlled by third-parties and which was developed back when LLVM was still using SVN expects a linear sequence of changes. The LLVM developers would like to do more with branching, but that would break the downstream tools over which they have no control, and so they are stuck with having to rebase everything. Thus rebase supports historical compatibility of legacy tooling. It's a reasonable argument in support of rebase, not one that I necessarily agree with, but one that I understand.

## Summary And Concluding Thoughts

GitHub is changing. It is important to understand that GitHub is moving away from being a Git Repository hosting company and towards a company that provides an entire ecosystem for software development. Git is still at the core, but the focus is no longer on Git.

Fossil already provides many of the features that GitHub wraps around Git. Prior to the meeting, someone told me that "GitHub is what make Git usable." Fossil has a lot of integrated capabilities that make GitHub unnecessary. Even so, there is always room for improvement and Fossil should be adapting and integrating ideas from other software development systems.

One GitHub-er asked me: "What would it take to get SQLite to move off of Fossil and on to Git." Just to be clear to everyone reading this: That will never happen. Fossil was specifically designed to support SQLite development and does so remarkably well. Fossil fills a different niche than does Git/GitHub. Fossil will continue to be supported and enhanced by me (as well as others) well into the foreseeable future.


[source](https://fossil-scm.org/forum/forumpost/448e5fd1c0)
