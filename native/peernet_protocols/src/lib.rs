#[macro_use] extern crate rustler;
#[macro_use] extern crate rustler_codegen;
#[macro_use] extern crate lazy_static;

use rustler::{NifEnv, NifTerm, NifResult, NifEncoder};
use rustler::types::list::NifListIterator;
use rustler::types::map::NifMapIterator;
use rustler::types::tuple::make_tuple;

mod wire_protocols;

mod atoms {
    rustler_atoms! {
        atom ok;
        //atom error;
        //atom __true__ = "true";
        //atom __false__ = "false";
    }
}

rustler_export_nifs! {
    "Elixir.EsprezzoCore.PeerNet.Protocols",
    [
        ("map_entries_sorted", 1, wire_protocols::map_entries_sorted),
        ("get_definition", 0, wire_protocols::get_definition)    
    ],
    None
}