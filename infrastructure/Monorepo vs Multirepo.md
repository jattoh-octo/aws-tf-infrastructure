![](/Users/jeffreyattoh/Library/CloudStorage/OneDrive-ZDAPT/OCTO/tf-iac/aws-tf-library/images/Git-Mono-vs-Multi-Repo_Hero.png)

# MONOREPO vs MULTIREPO: Which method for modularization?

### ***What is a Mono-repo?***

In a mono-repo approach, you can keep all your services in a single (mono) repository. You can still deploy and manage each service independently. The services can share common libraries and code.

#### Advantages of Mono-repo

Mono-repo approach has many advantages:

- A single place to store all the project code, and can be accessed by everyone in the team
- Easy to reuse and share code, collaborate with the team
- Easy to understand the impact of your change on the entire project
- The best option for code-refactoring and large changes to code
- Team members can get an overall view of the entire project
- Easy to manage dependencies

#### Disadvantages of Mono-repo

Of course, mono-repo has some disadvantages, the main one being the performance. If your project grows and more files are added every other day, the check-out, pull and other operations might become slow and file searches may take longer.

Also, if you manage a large team for your project, giving them access to the entire code base may not be so secure.

Further, it is difficult to implement Continuous Deployments (CD), because many people can check in their changes, and your Continuous Integration (CI) system may have to do multiple rebuilds.

Large companies that use mono-repos have customized tools to handle the scaling-up issues. For example, Facebook uses a custom file system and source control.

### ***What is a Multi-repo?***

In a multi-repo approach, there are multiple repositories that host several libraries and services of a project. If a service changes, developers need to rebuild only that service and not the entire project. Individuals and teams can work on their specific services and they get access to only the required services.

#### Advantages of Multi-repo

The number of companies adopting multi-repo is way more than those going for mono-repo, because of the following reasons:

- Each service and library have its own versioning
- Code check-outs and pulls are small and separate, thus there are no performance issues even if the project size grows
- Teams can work independently and need not have access to the entire codebase
- Faster development and flexibility
- Each service can be released separately and have its own deployment cycle, thus making CI and CD easier to implement
- Better access control – all teams need not have full access to all the libraries – but can get read access if they need

#### Disadvantages of Multi-repo

- The dependencies and libraries used across services and projects have to be regularly synced to get the latest version
- Encourages a siloed culture at some point, leading to duplicate code and individual teams trying to resolve the same problem
- Each team may follow a different set of best practices for their code causing difficulties in following common best practices

### Differences between Mono and Multi Repo

Let us recapitulate the differences between mono-repo and multi-repo:

| **Mono-repo**                                                | **Multi-repo**                                               |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| All the code of all the projects of an organization resides in a central repository | Each service and project have a separate  repository         |
| Teams can collaborate and work together; they can see each other’s changes | Teams can work autonomously; individual changes do not affect changes by other teams or projects |
| Each person gets access to the entire project structure      | Admins can limit access control to the project or service that the developer needs access to |
| Scale-up issues can occur if the project size keeps growing  | Good performance, because of the limited code and smaller units of service |
| Difficult to implement Continuous Deployment (CD) and Continuous Integration (CI) | Developers can easily achieve CD and CI because they can build services independently |
| Developers can easily share libraries, APIs, and other common code as they are updated in the central repository | Any changes to libraries and other common code should be periodically synced to avoid issues later |

### Conclusion

Both mono-repo and multi-repo are equally popular and which one is better depends on your project size, project requirements, and the level of versioning and access control you need.

Mono-repo favors consistency, whereas multi-repo focuses on decoupling. While in a mono-repo, the entire team can see changes done by one person, multi-repo creates a separate repo for each team, who have access to only the required services. If you want to use a combination of mono-repo and multi-repo for your projects, you can go for [meta](https://github.com/mateodelnorte/meta), a tool to manage multiple projects and libraries.