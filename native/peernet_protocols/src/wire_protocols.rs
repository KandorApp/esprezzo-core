use rustler::{NifEnv, NifTerm, NifEncoder, NifResult};
use rustler::types::map::NifMapIterator;
use rustler::types::tuple::make_tuple;

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
//
pub fn get_definition<'a>(env: NifEnv<'a>, args: &[NifTerm<'a>]) -> NifResult<NifTerm<'a>> {
    //let setting: ProtoDef = ProtoDef { name: "SUCCESS", term_index: "1" };
    let n = "settink"; 
    let v = "valuer"; 
    
    let num1: i64 = args[0].decode()?;
    let num2: i64 = args[1].decode()?;

    // let mut steez = ::rustler::types::map::map_new(env)
    // .map_put(n, v).ok().unwrap();

    let out_n: NifTerm = (n).encode(env);
    let out_v: NifTerm = (v).encode(env);

    let out_term: NifTerm = (v).encode(env);

    Ok((atoms::ok(), out_term).encode(env))
}