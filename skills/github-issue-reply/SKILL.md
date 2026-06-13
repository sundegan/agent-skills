---
name: github-issue-reply
description: Investigate and handle GitHub issues with natural, restrained, evidence-based maintainer replies, appropriate repository labels, and closure when no further tracking is needed. Use when responding to bug reports, feature requests, questions, or follow-ups where you should check whether the latest published release fixes or implements the request, link the relevant release, apply suitable existing labels, and close issues that are conclusively resolved.
---

# GitHub Issue Reply

## Goal

Produce a concise maintainer reply that sounds human, acknowledges useful feedback without exaggerated praise, and accurately tells the reporter whether the latest published version addresses the issue. Apply appropriate labels and close conclusively resolved issues that no longer need tracking.

## Workflow

1. Establish the repository and issue:
   - Read the complete issue title, body, labels, comments, linked pull requests, and referenced issues.
   - Identify the reported behavior, expected behavior, requested feature, affected version, platform, and reproduction details.
   - Determine the repository from the current Git remote or the issue URL. Do not guess when multiple repositories are possible.
   - Inspect the repository's existing labels and recent issue-labeling conventions before choosing labels.
2. Inspect the latest published release:
   - Prefer `gh release view --json tagName,name,publishedAt,url,isDraft,isPrerelease,body` and `gh release list` when GitHub CLI access is available.
   - Exclude drafts. Treat prereleases as the latest only when the issue concerns prerelease users or the user explicitly asks for them.
   - Inspect release notes, changelogs, merged pull requests, commits, and source code as needed. Search using the issue's feature names, error text, affected components, and likely synonyms.
   - Use the repository's actual release URL. Prefer the specific release page because it contains version details and assets; use the repository's `/releases/latest` URL only when a stable redirect is more appropriate.
3. Determine the result from evidence:
   - Mark **implemented or fixed** only when release notes, a merged change included in that release, or the released source clearly establishes the connection.
   - Mark **possibly related** when evidence is suggestive but incomplete. Ask the reporter to test without stating that the issue is fixed.
   - Mark **not yet implemented** when the latest release does not contain the requested behavior.
   - If there is no published release, say so plainly and do not invent a version or download link.
4. Draft the reply in the repository's established language and maintainer style:
   - Determine the reply language from the issue title, body, and full comment thread, not from the repository language alone.
   - Reply in Chinese when the reporter uses Chinese and the discussion is entirely or effectively Chinese.
   - Reply in English when the reporter and discussion use English.
   - Prefer English when participants use a mixture of Chinese and English, even if the original report is Chinese, so the reply remains accessible to everyone in the thread.
   - Follow an explicit language request from the user when one is provided.
   - Preserve code, error messages, product names, release names, and established technical terms in their original form when translating them would reduce clarity.
   - Build the reply from the specific issue context rather than selecting or filling a reusable response template.
   - Refer to the concrete behavior, requested capability, platform, reproduction detail, or discussion point that matters to the resolution.
   - Thank or compliment the reporter only when the context supports it. Make any acknowledgment specific to what was useful, such as a reproduction, log, diagnosis, or design suggestion.
   - Decide the order and contents from the situation. Include only the relevant combination of resolution, explanation, version, release link, upgrade detail, verification request, workaround, remaining limitation, and closure notice.
   - State the verified status clearly, but do not force every reply into the same opening, paragraph structure, or closing sentence.
   - Invite further testing or feedback only when it is useful. Tailor the requested follow-up to the unresolved risk instead of asking everyone to “try the latest version and let us know.”
5. Choose labels:
   - Reuse the repository's existing labels and naming conventions. Do not create a new label merely because a generic label name seems appropriate.
   - Apply the smallest useful set, such as the repository's equivalents of `bug`, `enhancement`, `question`, `duplicate`, `fixed`, `released`, `needs-info`, or a relevant component/platform label.
   - Preserve existing labels unless they are clearly incorrect or obsolete. Do not remove labels unrelated to the current resolution.
   - Do not apply mutually contradictory status labels.
6. Decide whether to close:
   - Close the issue only when the reported bug or requested feature is conclusively fixed or implemented in a published release and no further maintainer tracking is needed.
   - Keep the issue open when evidence is incomplete, the reporter still needs to verify an uncertain fix, the change exists only on an unreleased branch, additional work remains, or the issue tracks broader follow-up work.
   - A request to try a conclusively verified released fix does not by itself require keeping the issue open. Tell the reporter they can comment or open a new issue if the problem persists, following repository convention.
   - Use an appropriate close reason when the platform supports it and repository convention is clear. Do not classify a completed fix as “not planned.”
7. Execute the issue update:
   - When the user asks to reply to or handle an issue, post the comment, apply the selected labels, and then close it if the closure criteria are met.
   - Prefer `gh issue comment`, `gh issue edit --add-label`, and `gh issue close` when GitHub CLI access is available.
   - Perform the comment before closure so the resolution is visible in the issue timeline.
   - Re-read the resulting issue state to verify the comment, labels, and open/closed status.
   - Return only a draft and make no GitHub changes when the user explicitly asks for a draft, template, example, or review.
   - If authentication or permissions prevent an operation, report exactly which comment, label, or closure action was not completed.
8. Report the result:
   - Include the issue URL, posted reply status, labels added or retained, and whether the issue was closed.
   - Return only the publishable reply when the user asks for a draft.
   - When investigation details are useful, put a short evidence note after the draft, clearly separated from the publishable text.

## Tone

- Sound like a real maintainer: warm, direct, and economical.
- Avoid excessive enthusiasm, marketing language, canned support language, stock greetings, stock closings, emojis, repeated thanks, and multiple exclamation marks.
- Do not over-apologize or imply fault before the cause is known.
- Do not claim that feedback caused a release unless the timeline proves it.
- Mention the contributor's handle only when it reads naturally.
- Prefer concrete wording such as “This was fixed in v1.4.2” over vague wording such as “Good news, this should now be all sorted out.”

## Accuracy Rules

- Never manufacture a tag, release date, change description, download URL, or implementation status.
- Do not equate a change on the default branch with a published release. Verify that the relevant commit or pull request is contained in the release tag.
- Do not infer a fix solely because an issue was closed.
- Do not close solely because a related pull request was merged; verify that the change is published in the release named in the reply.
- Do not say “latest version” without checking the current published releases during this task.
- Distinguish release pages from direct asset links. Provide a direct asset only after verifying the correct operating system and architecture.
- If the reporter already tested the latest release, do not ask them to repeat the same test unless a newer relevant build exists.
- Preserve uncertainty when repository evidence is incomplete.

## Final Check

Before returning the reply, verify:

- The named version is currently published and is the appropriate stable or prerelease version.
- The claimed fix or feature is actually included in that version.
- The link resolves to the intended repository and release.
- The reply is Chinese for a Chinese-only discussion, English for an English discussion, and English for a mixed Chinese-English discussion unless the user explicitly requests otherwise.
- The wording and structure are derived from this issue's facts rather than a fixed template or repeated stock phrases.
- Any thanks, praise, follow-up request, and closure explanation are context-specific and necessary.
- The next step requested from the reporter is relevant and easy to follow.
- The selected labels already exist, match repository convention, and do not contradict one another.
- Closure is backed by a published fix or implementation and leaves no unresolved tracking work.
- The final GitHub issue state matches the intended comment, labels, and open/closed status.
