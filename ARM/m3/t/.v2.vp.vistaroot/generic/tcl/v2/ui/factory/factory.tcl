namespace eval ::v2::ui::factory {
  proc create_view {class docID} {
    return [::UI::create_view $class $docID]
  }

  proc create_dialog_view {class docID} {
    return [::UI::create_dialog_view $class $docID]
  }

  proc create_main_window {docID} {
    create_view ::v2::ui::mainwindow::MainFrame $docID
  }

  proc create_file_dialog_view {class docID} {
    create_dialog_view ::v2::ui::filedialog::$class $docID
  }

  proc create_project_dialog_view {class docID} {
    create_dialog_view ::v2::ui::projectdialog::$class $docID
  }

  proc create_new_library_dialog_view {docID} {
    create_dialog_view ::v2::ui::library::ExampleLibraryDialog $docID
  }

  proc create_library_manager_dialog_view {docID} {
    create_dialog_view ::v2::ui::LibraryManagerDialog $docID
  }
  
  proc create_filter_dialog_view {class docID} {
    create_dialog_view ::v2::ui::filterdialog::$class $docID
  }
  
  proc create_edit_dialog_view {class docID} {
    create_dialog_view ::v2::ui::editdialog::$class $docID
  }
  
  proc create_top_dialog_view {class docID} {
    create_dialog_view ::v2::ui::topdialog::$class $docID
  }

  proc create_clock_dialog_view {class docID} {
    create_dialog_view ::v2::ui::clockdialog::$class $docID
  }

  proc create_libgenerate_dialog_view {class docID} {
    create_dialog_view ::v2::ui::libgendialog::$class $docID
  }

  proc create_quit_simulation_dialog_view {class docID} {
    create_dialog_view ::v2::ui::quitsimulationdialog::$class $docID
  }

  proc create_simulation_dialog_view {class docID} {
    create_dialog_view ::v2::ui::simulationdialog::$class $docID
  }

  proc create_vp_dialog_view {class docID} {
    create_dialog_view ::v2::ui::vpdialog::$class $docID
  }

  proc create_license_dialog_view {class docID} {
    create_dialog_view ::v2::ui::licensedialog::$class $docID
  }

  proc create_inspect_dialog_view {class docID} {
    create_dialog_view ::v2::ui::inspectdialog::$class $docID
  }

  proc create_path_variables_adder_view {class docID args} {
    catch {
      set view [eval ::Utilities::tkObjectNewInit $class \
                    [::Utilities::objectNew ::Document::Document $docID] $args]
      $view show
    }
  }

  proc create_create_pathvariable_dialog_view {class docID} {
    create_dialog_view ::v2::ui::path_variables_adder::$class $docID
  }
  
  proc create_create_folder_dialog_view {class docID} {
    create_dialog_view ::v2::ui::projectdialog::$class $docID
  }
  
  proc create_simulation_control {docID} {
    create_view ::v2::ui::simulation_control::TopView $docID
  }
  
  proc create_tlminfra_dialog_view {class docID} {
    create_dialog_view ::v2::ui::tlminfradialog::$class $docID
  }

  proc create_trace_dialog_view {class docID} {
    create_dialog_view ::v2::ui::trace_dialog::$class $docID
  }

  proc create_view_options_dialog_view {class docID} {
    create_dialog_view ::v2::ui::view_options::$class $docID
  }

  proc create_analysis_reports_dialog_view {class docID} {
    create_dialog_view ::v2::ui::analysis_report_dialog::$class $docID
  }
  
  proc create_conffromipxact_dialog_view {class docID} {
    create_dialog_view ::v2::ui::conffromipxact_dialog::$class $docID
  }
}
