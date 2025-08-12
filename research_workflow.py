#!/usr/bin/env python3
"""
Research Workflow Manager
Integrates Bean, TexStudio, LaTeX, and SciSpace for streamlined research workflow
"""

import os
import sys
import json
import argparse
from pathlib import Path
from datetime import datetime
from research_file_manager import ResearchFileManager

class ResearchWorkflow:
    """Manages the complete research workflow from research to final submission."""
    
    def __init__(self, config_path: str = "config.json"):
        self.manager = ResearchFileManager(config_path)
        self.config = self.manager.config
        
    def create_research_project(self, project_name: str, project_type: str = "article"):
        """Create a new research project with all necessary files and templates."""
        print(f"🚀 Creating new research project: {project_name}")
        
        # Create project directory
        project_dir = Path(self.config['research_base_dir']).expanduser() / "Projects" / project_name
        project_dir.mkdir(parents=True, exist_ok=True)
        
        # Create subdirectories
        (project_dir / "Research").mkdir(exist_ok=True)
        (project_dir / "Writing").mkdir(exist_ok=True)
        (project_dir / "Drafts").mkdir(exist_ok=True)
        (project_dir / "Final").mkdir(exist_ok=True)
        (project_dir / "Bibliography").mkdir(exist_ok=True)
        
        print(f"📁 Project structure created at: {project_dir}")
        
        # Create appropriate templates based on project type
        if project_type in ["article", "paper", "journal"]:
            self._create_article_templates(project_dir, project_name)
        elif project_type in ["thesis", "dissertation"]:
            self._create_thesis_templates(project_dir, project_name)
        elif project_type in ["report", "technical"]:
            self._create_report_templates(project_dir, project_name)
        
        # Create project metadata
        project_meta = {
            "project_name": project_name,
            "project_type": project_type,
            "created_date": datetime.now().isoformat(),
            "status": "active",
            "last_modified": datetime.now().isoformat()
        }
        
        with open(project_dir / "project_metadata.json", 'w') as f:
            json.dump(project_meta, f, indent=2, default=str)
        
        print(f"✅ Project '{project_name}' created successfully!")
        return project_dir
    
    def _create_article_templates(self, project_dir: Path, project_name: str):
        """Create templates for journal articles."""
        # Create Bean template
        bean_template = self.manager.create_bean_template(
            f"{project_name}_Article", 
            self._get_article_rtf_template(project_name)
        )
        if bean_template:
            shutil.copy(bean_template, project_dir / "Writing" / f"{project_name}_Article.rtf")
        
        # Create LaTeX template
        latex_template = self.manager.create_latex_template(
            f"{project_name}_Article", 
            "article"
        )
        if latex_template:
            shutil.copy(latex_template, project_dir / "Writing" / f"{project_name}_Article.tex")
        
        # Create bibliography file
        bib_file = project_dir / "Bibliography" / f"{project_name}_references.bib"
        bib_file.write_text(self._get_bibtex_template())
        
        print(f"📝 Created article templates for {project_name}")
    
    def _create_thesis_templates(self, project_dir: Path, project_name: str):
        """Create templates for thesis/dissertation."""
        # Create Bean template
        bean_template = self.manager.create_bean_template(
            f"{project_name}_Thesis",
            self._get_thesis_rtf_template(project_name)
        )
        if bean_template:
            shutil.copy(bean_template, project_dir / "Writing" / f"{project_name}_Thesis.rtf")
        
        # Create LaTeX template
        latex_template = self.manager.create_latex_template(
            f"{project_name}_Thesis",
            "report"
        )
        if latex_template:
            shutil.copy(latex_template, project_dir / "Writing" / f"{project_name}_Thesis.tex")
        
        print(f"📝 Created thesis templates for {project_name}")
    
    def _create_report_templates(self, project_dir: Path, project_name: str):
        """Create templates for technical reports."""
        # Create Bean template
        bean_template = self.manager.create_bean_template(
            f"{project_name}_Report",
            self._get_report_rtf_template(project_name)
        )
        if bean_template:
            shutil.copy(bean_template, project_dir / "Writing" / f"{project_name}_Report.rtf")
        
        print(f"📝 Created report templates for {project_name}")
    
    def _get_article_rtf_template(self, project_name: str) -> str:
        """Get RTF template for journal articles."""
        return f"""{{\\rtf1\\ansi\\deff0 {{\\fonttbl {{\\f0 Times;}}}}
{{\\colortbl ;\\red0\\green0\\blue0;}}
\\f0\\fs24 {project_name}\\par
\\par
\\b Title:\\b0 \\par
\\par
\\b Authors:\\b0 \\par
\\par
\\b Abstract:\\b0 \\par
\\par
\\b Keywords:\\b0 \\par
\\par
\\b 1. Introduction:\\b0 \\par
\\par
\\b 2. Literature Review:\\b0 \\par
\\par
\\b 3. Methodology:\\b0 \\par
\\par
\\b 4. Results:\\b0 \\par
\\par
\\b 5. Discussion:\\b0 \\par
\\par
\\b 6. Conclusion:\\b0 \\par
\\par
\\b References:\\b0 \\par
}}"""
    
    def _get_thesis_rtf_template(self, project_name: str) -> str:
        """Get RTF template for thesis/dissertation."""
        return f"""{{\\rtf1\\ansi\\deff0 {{\\fonttbl {{\\f0 Times;}}}}
{{\\colortbl ;\\red0\\green0\\blue0;}}
\\f0\\fs24 {project_name}\\par
\\par
\\b Title Page:\\b0 \\par
\\par
\\b Abstract:\\b0 \\par
\\par
\\b Table of Contents:\\b0 \\par
\\par
\\b List of Figures:\\b0 \\par
\\par
\\b List of Tables:\\b0 \\par
\\par
\\b Chapter 1: Introduction:\\b0 \\par
\\par
\\b Chapter 2: Literature Review:\\b0 \\par
\\par
\\b Chapter 3: Methodology:\\b0 \\par
\\par
\\b Chapter 4: Results:\\b0 \\par
\\par
\\b Chapter 5: Discussion:\\b0 \\par
\\par
\\b Chapter 6: Conclusion:\\b0 \\par
\\par
\\b Appendices:\\b0 \\par
\\par
\\b Bibliography:\\b0 \\par
}}"""
    
    def _get_report_rtf_template(self, project_name: str) -> str:
        """Get RTF template for technical reports."""
        return f"""{{\\rtf1\\ansi\\deff0 {{\\fonttbl {{\\f0 Times;}}}}
{{\\colortbl ;\\red0\\green0\\blue0;}}
\\f0\\fs24 {project_name}\\par
\\par
\\b Executive Summary:\\b0 \\par
\\par
\\b 1. Introduction:\\b0 \\par
\\par
\\b 2. Background:\\b0 \\par
\\par
\\b 3. Methods:\\b0 \\par
\\par
\\b 4. Results:\\b0 \\par
\\par
\\b 5. Analysis:\\b0 \\par
\\par
\\b 6. Recommendations:\\b0 \\par
\\par
\\b 7. Conclusion:\\b0 \\par
\\par
\\b References:\\b0 \\par
}}"""
    
    def _get_bibtex_template(self) -> str:
        """Get basic BibTeX template."""
        return """@article{example2024,
  title={Example Research Paper},
  author={Author, A. and Author, B.},
  journal={Journal of Examples},
  volume={1},
  number={1},
  pages={1--10},
  year={2024},
  publisher={Example Publisher}
}

@book{examplebook2024,
  title={Example Book},
  author={Author, C.},
  year={2024},
  publisher={Example Publisher},
  address={Example City}
}"""
    
    def open_project_in_editor(self, project_name: str, editor: str = "auto"):
        """Open a research project in the appropriate editor."""
        project_dir = Path(self.config['research_base_dir']).expanduser() / "Projects" / project_name
        
        if not project_dir.exists():
            print(f"❌ Project '{project_name}' not found")
            return False
        
        # Find writing files
        writing_dir = project_dir / "Writing"
        if not writing_dir.exists():
            print(f"❌ Writing directory not found for project '{project_name}'")
            return False
        
        # Auto-detect editor based on available files
        if editor == "auto":
            tex_files = list(writing_dir.glob("*.tex"))
            rtf_files = list(writing_dir.glob("*.rtf"))
            doc_files = list(writing_dir.glob("*.doc*"))
            
            if tex_files:
                editor = "texstudio"
                file_to_open = tex_files[0]
            elif rtf_files:
                editor = "bean"
                file_to_open = rtf_files[0]
            elif doc_files:
                editor = "bean"
                file_to_open = doc_files[0]
            else:
                print(f"❌ No writing files found in project '{project_name}'")
                return False
        else:
            # Find file for specified editor
            if editor == "texstudio":
                file_to_open = next(writing_dir.glob("*.tex"), None)
            elif editor == "bean":
                file_to_open = next(writing_dir.glob("*.rtf"), None) or next(writing_dir.glob("*.doc*"), None)
            else:
                print(f"❌ Unknown editor: {editor}")
                return False
            
            if not file_to_open:
                print(f"❌ No suitable files found for editor '{editor}'")
                return False
        
        # Open file in appropriate editor
        if editor == "texstudio":
            return self.manager.open_in_texstudio(file_to_open)
        elif editor == "bean":
            return self.manager.open_in_bean(file_to_open)
        
        return False
    
    def compile_project(self, project_name: str):
        """Compile a LaTeX project to PDF."""
        project_dir = Path(self.config['research_base_dir']).expanduser() / "Projects" / project_name
        
        if not project_dir.exists():
            print(f"❌ Project '{project_name}' not found")
            return False
        
        # Find main LaTeX file
        writing_dir = project_dir / "Writing"
        tex_files = list(writing_dir.glob("*.tex"))
        
        if not tex_files:
            print(f"❌ No LaTeX files found in project '{project_name}'")
            return False
        
        # Compile main file
        main_tex = tex_files[0]
        print(f"🔨 Compiling LaTeX project: {main_tex.name}")
        
        success = self.manager.compile_latex(main_tex)
        
        if success:
            # Move compiled PDF to Final directory
            pdf_file = main_tex.with_suffix('.pdf')
            if pdf_file.exists():
                final_dir = project_dir / "Final"
                final_dir.mkdir(exist_ok=True)
                
                final_pdf = final_dir / f"{project_name}_Final.pdf"
                pdf_file.rename(final_pdf)
                print(f"✅ Project compiled successfully: {final_pdf}")
                return True
        
        print(f"❌ Failed to compile project '{project_name}'")
        return False
    
    def list_projects(self):
        """List all research projects."""
        projects_dir = Path(self.config['research_base_dir']).expanduser() / "Projects"
        
        if not projects_dir.exists():
            print("📁 No projects directory found")
            return
        
        projects = [d for d in projects_dir.iterdir() if d.is_dir()]
        
        if not projects:
            print("📁 No research projects found")
            return
        
        print(f"📚 Found {len(projects)} research projects:\n")
        
        for project in sorted(projects):
            meta_file = project / "project_metadata.json"
            if meta_file.exists():
                try:
                    with open(meta_file, 'r') as f:
                        meta = json.load(f)
                    status = meta.get('status', 'unknown')
                    created = meta.get('created_date', 'unknown')[:10]
                    print(f"  📁 {project.name}")
                    print(f"     Type: {meta.get('project_type', 'unknown')}")
                    print(f"     Status: {status}")
                    print(f"     Created: {created}")
                    print()
                except:
                    print(f"  📁 {project.name} (metadata error)")
            else:
                print(f"  📁 {project.name} (no metadata)")
    
    def process_scispace_export(self, export_file: str):
        """Process a SciSpace export and integrate it into the research system."""
        export_path = Path(export_file)
        
        if not export_path.exists():
            print(f"❌ Export file not found: {export_file}")
            return False
        
        print(f"🔬 Processing SciSpace export: {export_path.name}")
        
        success = self.manager.process_scispace_export(export_path)
        
        if success:
            print(f"✅ SciSpace export processed successfully")
            return True
        else:
            print(f"❌ Failed to process SciSpace export")
            return False

def main():
    """Main function for the research workflow manager."""
    parser = argparse.ArgumentParser(description='Research Workflow Manager')
    parser.add_argument('--config', default='config.json', help='Configuration file path')
    
    subparsers = parser.add_subparsers(dest='command', help='Available commands')
    
    # Create project command
    create_parser = subparsers.add_parser('create', help='Create a new research project')
    create_parser.add_argument('name', help='Project name')
    create_parser.add_argument('--type', choices=['article', 'thesis', 'report'], 
                              default='article', help='Project type')
    
    # Open project command
    open_parser = subparsers.add_parser('open', help='Open a project in editor')
    open_parser.add_argument('name', help='Project name')
    open_parser.add_argument('--editor', choices=['auto', 'bean', 'texstudio'], 
                            default='auto', help='Editor to use')
    
    # Compile project command
    compile_parser = subparsers.add_parser('compile', help='Compile a LaTeX project')
    compile_parser.add_argument('name', help='Project name')
    
    # List projects command
    subparsers.add_parser('list', help='List all research projects')
    
    # Process SciSpace export command
    export_parser = subparsers.add_parser('scispace', help='Process SciSpace export')
    export_parser.add_argument('file', help='Export file path')
    
    args = parser.parse_args()
    
    if not args.command:
        parser.print_help()
        return
    
    # Initialize workflow manager
    workflow = ResearchWorkflow(args.config)
    
    if args.command == 'create':
        workflow.create_research_project(args.name, args.type)
    elif args.command == 'open':
        workflow.open_project_in_editor(args.name, args.editor)
    elif args.command == 'compile':
        workflow.compile_project(args.name)
    elif args.command == 'list':
        workflow.list_projects()
    elif args.command == 'scispace':
        workflow.process_scispace_export(args.file)

if __name__ == "__main__":
    import shutil
    main()
