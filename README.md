# Template: Gem

A template project for generating Ruby gems.

1. Go to [Generate](../../generate)
2. Enter the new repo name and click "Create Repository"
3. Add the repository to [Contributor Assets](../../../contributor-assets)
4. Run `get-projects.sh` from contributor-assets
5. Enter the repo directory and run:

   ```sh
   ./rename.sh ws-some_namespace-other_namespace SomeNamespace::OtherNamespace
   git add .
   git commit -m "Project is renamed"
   ```

   For more information on naming gems and namespaces, see the RubyGems naming guide:
   [https://guides.rubygems.org/name-your-gem/](https://guides.rubygems.org/name-your-gem/)
6. Publish the gem at e.g. v0.0.0.0
7. Add a description of the project to the README
