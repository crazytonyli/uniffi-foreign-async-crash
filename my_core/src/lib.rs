use std::fmt::Debug;

#[uniffi::export(with_foreign)]
#[async_trait::async_trait]
pub trait AsyncTrait: Send + Sync + Debug {
    async fn async_fn(&self) -> String;
}

pub struct MyStruct;

uniffi::setup_scaffolding!();
