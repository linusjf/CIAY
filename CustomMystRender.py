from myst_parser import MystRenderer

class CustomMystRenderer(MystRenderer):
    def render_document(self, document):
        lines = document.split('\n')
        filtered_lines = []
        in_toc = False

        for line in lines:
            if line.strip().startswith('<!-- toc -->'):
                in_toc = True
            elif line.strip().startswith('<!-- tocstop -->'):
                in_toc = False
            elif not in_toc:
                filtered_lines.append(line)

        return '\n'.join(filtered_lines)
