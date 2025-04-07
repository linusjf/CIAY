from sphinx.application import Sphinx

class TOCExtension(Sphinx):
    def build(self):
        # Filter out lines between <!-- toc --> and <!-- tocstop -->
        for doc in self.env.found_docs:
            text = self.env.doc2path[doc]
            lines = text.split('\n')
            filtered_lines = []
            in_toc = False

            for line in lines:
                if line.strip().startswith('<!-- toc -->'):
                    in_toc = True
                elif line.strip().startswith('<!-- tocstop -->'):
                    in_toc = False
                elif not in_toc:
                    filtered_lines.append(line)

            self.env.doc2path[doc] = '\n'.join(filtered_lines)

        # Call the parent build method
        super().build()

