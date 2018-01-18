use rustler::{NifEnv, NifTerm, NifEncoder, NifResult};
use rustler::types::map::NifMapIterator;
use rustler::types::tuple::make_tuple;
extern crate hex;

#[derive(Debug)]
struct ProtoDef<'a> {
    name: &'a str,
    term_index: &'a str,
}

mod atoms {
    rustler_atoms! {
        atom ok;
        //atom error;
        //atom __true__ = "true";
        //atom __false__ = "false";
    }
}


pub fn map_entries_sorted<'a>(env: NifEnv<'a>, args: &[NifTerm<'a>]) -> NifResult<NifTerm<'a>> {
    
    let iter: NifMapIterator = args[0].decode()?;

    let mut vec = vec![];
    for (key, value) in iter {
        let key_string = key.decode::<String>()?;
        vec.push((key_string, value));
    }

    vec.sort_by_key(|pair| pair.0.clone());
    let erlang_pairs: Vec<NifTerm> =
        vec.into_iter()
        .map(|(key, value)| make_tuple(env, &[key.encode(env), value]))
        .collect();
    Ok(erlang_pairs.encode(env))
}

//
// http://hansihe.com/2017/02/05/rustler-safe-erlang-elixir-nifs-in-rust.html
// println!("{}", hex_string);
pub fn get_definition<'a>(env: NifEnv<'a>, args: &[NifTerm<'a>]) -> NifResult<NifTerm<'a>> {

    let mut vec: Vec<(String, &str)> = Vec::new();
    let hello_msg            = (format!("{:#X}", 0), "hello"); //returns version if compatible or disconnect
    let disco_msg            = (format!("{:#X}", 1), "disconnect"); // end session
    let req_block_hashes_msg = (format!("{:#X}", 2), "get_block_hashes"); //request hashes only
    
    vec.push(hello_msg);
    vec.push(disco_msg);
    vec.push(req_block_hashes_msg);

    let erlang_pairs: Vec<NifTerm> =
        vec.into_iter()
        .map(|(key, value)| make_tuple(env, &[key.encode(env), value.encode(env)]))
        .collect();
    Ok(erlang_pairs.encode(env))
}