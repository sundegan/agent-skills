---
name: github-issue-reply
description: Investigate GitHub issues and draft natural, restrained, evidence-based maintainer replies. Use when responding to bug reports, feature requests, questions, or follow-ups where you should thank the reporter when appropriate, check whether the latest published release already fixes or implements the request, provide the relevant release or download link, and invite the reporter to try the latest version without making unverified claims.
---

# GitHub Issue Reply

## Goal

Produce a concise maintainer reply that sounds human, acknowledges useful feedback without exaggerated praise, and accurately tells the reporter whether the latest published version addresses the issue.

## Workflow

1. Establish the repository and issue:
   - Read the complete issue title, body, labels, comments, linked pull requests, and referenced issues.
   - Identify the reported behavior, expected behavior, requested feature, affected version, platform, and reproduction details.
   - Determine the repository from the current Git remote or the issue URL. Do not guess when multiple repositories are possible.
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
   - Match the dominant language in the issue unless the user requests another language.
   - Thank the reporter for a useful bug report, clear reproduction, or thoughtful suggestion when appropriate.
   - Keep praise specific and modest. One brief acknowledgment is usually enough.
   - State the verified status and version early.
   - Link the relevant release using Markdown.
   - Invite the reporter to try that version and report back if the behavior remains.
   - Add upgrade, migration, platform, or configuration details only when they are relevant and verified.
5. Present a draft unless the user explicitly asks to post it:
   - Return only the publishable reply when the user asks for a reply or draft.
   - When investigation details are useful, put a short evidence note after the draft, clearly separated from the publishable text.
   - Never post, comment, close, label, or otherwise modify an issue without explicit user authorization.

## Tone

- Sound like a real maintainer: warm, direct, and economical.
- Avoid excessive enthusiasm, marketing language, canned support language, emojis, repeated thanks, and multiple exclamation marks.
- Do not over-apologize or imply fault before the cause is known.
- Do not claim that feedback caused a release unless the timeline proves it.
- Mention the contributor's handle only when it reads naturally.
- Prefer concrete wording such as “This was fixed in v1.4.2” over vague wording such as “Good news, this should now be all sorted out.”

## Reply Patterns

Use these as structures, not fixed templates.

### Verified Fix

```markdown
Thanks for the clear report. This was fixed in [v1.4.2](RELEASE_URL).

Please try the latest version when you have a chance. If you can still reproduce the problem there, let us know your platform and the relevant logs and we can take another look.
```

### Verified Feature

```markdown
Thanks for the suggestion. Support for this was added in [v2.1.0](RELEASE_URL).

You can download the latest version from that release. Please give it a try, and let us know if the current behavior does not cover your use case.
```

### Evidence Is Incomplete

```markdown
Thanks for reporting this. [v1.4.2](RELEASE_URL) includes changes in this area, but I could not confirm that they cover this exact case.

Could you try that version and let us know whether the issue still occurs?
```

### Not Yet Implemented

```markdown
Thanks for the suggestion. I checked the latest release, [v2.1.0](RELEASE_URL), and this is not implemented there yet.

We will keep this issue open to track the request.
```

## Accuracy Rules

- Never manufacture a tag, release date, change description, download URL, or implementation status.
- Do not equate a change on the default branch with a published release. Verify that the relevant commit or pull request is contained in the release tag.
- Do not infer a fix solely because an issue was closed.
- Do not say “latest version” without checking the current published releases during this task.
- Distinguish release pages from direct asset links. Provide a direct asset only after verifying the correct operating system and architecture.
- If the reporter already tested the latest release, do not ask them to repeat the same test unless a newer relevant build exists.
- Preserve uncertainty when repository evidence is incomplete.

## Final Check

Before returning the reply, verify:

- The named version is currently published and is the appropriate stable or prerelease version.
- The claimed fix or feature is actually included in that version.
- The link resolves to the intended repository and release.
- The reply matches the issue language and does not exaggerate praise or certainty.
- The next step requested from the reporter is relevant and easy to follow.
